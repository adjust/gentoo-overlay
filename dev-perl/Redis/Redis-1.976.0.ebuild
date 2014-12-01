# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=DAMS
MODULE_VERSION=1.976
inherit perl-module

DESCRIPTION="Perl binding for Redis database"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-perl/IO-Socket-Timeout
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? (
		virtual/perl-Digest-SHA
		dev-perl/IO-String
		virtual/perl-IPC-Cmd
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/Test-SharedFork
		dev-perl/Test-TCP
	)
"

mytargets="install"
