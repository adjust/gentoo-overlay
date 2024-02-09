#!/usr/bin/perl

use strict;
use warnings;
use v5.26;

use Getopt::Long;
use Pod::Usage;
use Time::Piece;
use Time::Seconds;
use Try::Tiny;
use JSON;
use Sys::Hostname;
use HTTP::Request;
use LWP::UserAgent;

use Data::Dumper;

my ($help, $verbose, $time, $parser, $json, $prometheus, $name);
my $base_uri = "/insert/prometheus/api/v1/import/prometheus";

GetOptions(
    "h|help" => \$help,
    "t|time=i" => \$time,
    "v|verbose" => \$verbose,
    "p|parser=s" => \&_parse_handler,
    "j|json" => \$json,
    "n|name=s" => \$name
) or _help(2);
_parse_handler('parser','stats') unless $parser;

@ARGV // _help();
$time //=  600;

_help() if $help;

############################################################
#
sub _help
{
    pod2usage(
        {
            -exitval => ($_[0] // $_),
            -verbose => 2
        }
    );
}

sub vprint
{
    say STDERR join(' ',@_) if $verbose;
}

sub _output
{
    my $data = shift;

    if ($json) {
        $json = JSON->new;
        $json->canonical([1]);
        say $json->pretty->encode($data);
    } else {
        say delete $${data}{file};
        say "----------------------------------";
        foreach (sort keys %$data) {
            if (ref $_ !~ m/HASH|ARRAY/) {
                say $_ . ":\t\t" . $$data{$_};
            } else {
                say $_ . ":";
                _print_pretty($$data{$_});
            }
        }
    }
}

sub _print_pretty
{
    my $data = shift;
    my $depth = shift || 0;

    if(ref $data eq 'ARRAY') {
        print ("\t" x ($depth+1));
        say "--------";
        foreach (@$data) {
            _print_pretty($_,$depth+1);
        }
        print ("\t" x ($depth+1));
        say "-------";
    } elsif (ref $data eq 'HASH') {
        foreach (sort keys(%$data)) {
            print ("\t" x $depth);
            print $_ . ": ";
            _print_pretty($$data{$_},$depth+1);
        }
    } else {
        print ("\t" x $depth);
        say $data;
    }
}

sub _parse_handler
{
    my ($opt_name, $opt_value) = @_;
    $parser = \&_parse_stats
        if ($opt_value eq 'stats');
    $parser = \&_parse_throughput
        if ($opt_value eq 'throughput');
    $parser = \&_parse_kafkaerr
        if ($opt_value eq 'kafkaerr');
    $parser = \&_parse_prometheus and $prometheus = 1
        if ($opt_value eq 'prometheus');

    _help(1)
        unless ref $parser eq 'CODE';
}

sub _parse_kafkaerr
{
    my $fh = shift;
    my $result = {};

    while(<$fh>)
    {
        my $match = _extract_kafkaerr($_);
        next unless $match;
        my $date = _extract_date($_);

        push @{$$result{kafkaerr}},
            {
                date => $date->epoch,
                match => $match
            };
    }
    return $result;
}

sub _parse_throughput
{
    my $fh = shift;
    my $delivered;

    while(<$fh>)
    {
        $delivered = _extract_delivered($_);
        last if $delivered;
    }

    return {'delivered' => $delivered};
}

sub _parse_stats
{
    my $fh = shift;

    my ($total, $i);
    my @results;
    my $return = {};
    while(<$fh>)
    {
        my $delivered = _extract_delivered($_);
        next unless $delivered;

        push @results, $delivered;
        $total += $delivered;
        $i++;
    }

    $$return{Median} = $results[$#results/2];
    $$return{Mean} = ($total/$i);

    my @sorted = sort {$a <=> $b} (@results);
    $$return{"01%"} = $sorted[$#sorted/100*1];
    $$return{"05%"} = $sorted[$#sorted/100*5];
    $$return{"10%"} = $sorted[$#sorted/100*10];
    $$return{"20%"} = $sorted[$#sorted/100*20];
    $$return{"80%"} = $sorted[$#sorted/100*80];
    $$return{"90%"} = $sorted[$#sorted/100*90];
    $$return{"95%"} = $sorted[$#sorted/100*95];
    $$return{"99%"} = $sorted[$#sorted/100*99];

    return $return;
}

sub _extract_kafkaerr
{
    my $line = shift;
    my $result;

    ($result) = $line =~ m|(src\/kafka.c.*$)|;
    return $result;
}

sub _extract_delivered
{
    my $line = shift;
    my $result;

    ($result) = $line =~ m|delivered / s: (\d+)$|;
    return $result;
}

sub _extract_autocommited
{
    my $line = shift;
    my $result;

    ($result) = $line =~ m|Autocommiting (\d+) entries|;
    return $result;
}

sub _extract_rebalance
{
    my $topic = shift;
    my $line = shift;
    my $result;
    # remove possible plural/singular mismatches
    $topic =~ s/s$//;
    ($result) = $line =~ m|$topic.+offset -1001$|;

    return 1 if $result;
}

sub _extract_date
{
    my $string = shift;
    my $result;
    $string =~ m/(^\w+\s+\w+\s+\d+\s+\d{2}:\d{2}:\d{2} \d{4})/ || return 0;

    try {
        $result = Time::Piece->strptime("$1",
            "%a %b %d %T %Y");
    } catch {
        vprint("Time::Piece returned: $_");
        vprint("Input: $1");
        $result = 0;
    };

    return $result;
}

sub _is_spam
{
    return $_[0] =~ m/(assigned|Consumer group rebalanced|revoked):$/;
}

sub _left_seek_newline
{
    my $fh = shift;
    my $r;

    while(read($fh,$r,1) != 0) {
        if(tell($fh) == 1) { # we reached the start
            seek($fh,-1,1);
            last;
        }
        if($r eq "\n") {
            last;
        }
        seek($fh,-2,1); # seek one byte to the left
    }
}

sub _find_offset
{
    my $fh = shift;
    my $file = shift;
    my $past = shift;

    my $seconds = localtime;
    $seconds = $seconds - $past;

    my $result = 0;
    my $last_pos = 0;

    my $size = (stat($fh))[7];
    vprint("$file: ${size} bytes");

    my $seek = int($size/2);

    # half file offset until desired timestamp is found
    while($seek > 0) {
        my $t;

        # read downwards until timestamp
        my $last_pos = tell($fh); # store last offset before reading
        _left_seek_newline($fh);
        OUTER: while (my $line = <$fh>) {
            $t = _extract_date($line);
            if (ref $t eq 'Time::Piece') { #instantiating check
                $t = $t - $seconds;
                vprint("$file: $last_pos diff ${t}s");
                last OUTER;
            }
        }

        if (ref $t ne 'Time::Seconds') {
            vprint("Failed to extract timestamp before EOF");
            die;
        }

        if ($t->seconds < -10) {
            vprint("seeking: -$seek bytes");
            seek($fh,$last_pos,0);
            seek($fh,$seek,1);
        } elsif ($t->seconds >10) {
            vprint("seeking: $seek bytes");
            seek($fh,$last_pos,0);
            seek($fh,-$seek,1);
        } else {
            vprint("$file: offset ". tell($fh) ." diff "
                . $t->seconds . "s is close enough");

            return 1;
        }
        $seek = int($seek/2);
    }
    vprint("$file: desired offset for $past does not exist");
    return 0;
}
sub _send_victoriametrics
{
	my $data = shift;
	my $req_prometheus = HTTP::Request->new('POST');
	my $ua = LWP::UserAgent->new;
	my $req_res, my $url = "";
	$req_prometheus->content($data);
	for (my $i = 1; $i <= 4; $i++) {
		$url = "http://ams-metrics-$i.adjust.com$base_uri";
		$req_prometheus->uri($url);
		$req_res = $ua->request($req_prometheus);
		last if $req_res->is_success;
	}
}
sub _parse_prometheus
{
    my $file = shift;
    my $id = $name ? $name : hostname();
    # turns out tail is much better than anything
    # I can whip up in perl on short notice
    open(my $fh, '-|', "tail -n0 -f $file 2>/dev/null")
        or die ("Can't tail $file: $!");

    my ($topic) = $file =~ m/(?:schaufel_?)?(?:exports_?)?(?:[a-z0-9]+\.)?([^\/]+?)\.log/;
	my $grafana_delivered = "schaufel_delivered{ topic=\"$topic\" , host=\"".$id."\" }" ;
    my $grafana_kafkaerr = "schaufel_kafkaerr{ topic=\"$topic\" , host=\"".$id."\" }" ;
    my $grafana_autocommit = "schaufel_autocommit{ topic=\"$topic\" , host=\"".$id."\" }" ;
    my $grafana_rebalance = "schaufel_rebalanced{ topic=\"$topic\" , host=\"".$id."\" }" ;

    # using http connections to prometheus
	my $data = "";
    while(my $line  = <$fh>)
    {
		$data = "";
        next if _is_spam($line);
        my $res;
        my $ts = _extract_date($line) || time();
		$ts = $ts->epoch if (ref($ts) eq 'Time::Piece');
        if ($res = _extract_delivered($line))
        {
            $data = "$grafana_delivered $res $ts";
            vprint("$topic $ts $res");
        }
        elsif ($res = _extract_kafkaerr($line))
        {
            $data = "$grafana_kafkaerr $res $ts";
            vprint("$topic $ts $res");
        }
        elsif ($res = _extract_autocommited($line))
        {
            $data = "$grafana_autocommit $res $ts";
            vprint("$topic $ts $res");
        }
        elsif ($res = _extract_rebalance($topic,$line))
        {
            $data = "$grafana_rebalance $res $ts";
            vprint("$topic $ts $res");
        }
        else
        {
            say STDERR "$topic: Failed to parse: $line";
        }
		_send_victoriametrics($data) unless $data eq "";
    }

    close($fh);
}

#
############################################################
sub main
{
    my @children;
    foreach my $file (@ARGV) {
        if ($prometheus) {
            my $pid = fork();
            if (!defined $pid) {
                kill 'TERM', @children;
                die "Failed to fork!";
            }
            push @children, $pid if $pid;
            vprint("Started worker $pid!") if $pid;
            next if $pid;

            # we're a worker now
            _parse_prometheus($file);
            exit;
        } else {
            open(my $fh, '<', $file) ||
                die("Error: Could not open file: $_");
            my $res = _find_offset($fh,$file,$time);

            my $output = {};
            $output = &$parser($fh) if $res; # nothing to parse if no result
            close $fh;
            $$output{file} = $file;
            _output($output);
        }
    }

    # lazy child reaper
    while (@children) {
        my $kid = waitpid(-1,0);
        vprint("Reaped process: $kid");
        # kill the others (consistent state)
        @children = grep { $_ != $kid } @children;
        kill 'TERM', @children;
    }

    exit 0;
}

main();

__END__
=head1 parseSchaufelLog.pl

Reliably parse Schaufel logfiles

=head1 SYNOPSIS

parseSchaufelLog.pl [-h] [-t seconds] [-v] [-J] [-p parser] [-s host:port] file ...

Options:

    -j|--json       output json
    -h|--help       this help screen
    -t|--time       seconds to seek backwards into schaufel (default 600)
    -p|--parser     parser to use. defaults to 'stats'
                    available:
                        stats      - statistical analysis
                        kafkaerr   - kafka errors
                        throughput - throughput next to timestamp
                        prometheus    - continously output to victoriametrics prometheus endpoints
