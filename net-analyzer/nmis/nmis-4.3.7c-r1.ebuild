# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions webapp

DESCRIPTION="Network Management Information System"
HOMEPAGE="https://opmantek.com/network-management-system-nmis/"
SRC_URI="https://files.adjust.com/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="+mysql postgres"

# Below are optional w/ IUSE:
# TODO: dev-perl/GD-Graph
# TODO: dev-perl/Net-EasyTCP
DEPEND="dev-lang/perl:="

need_httpd_cgi # Extends DEPEND.

RDEPEND="
	acct-group/nmis
	acct-user/nmis

	${DEPEND}
	dev-perl/BSD-Resource
	dev-perl/CGI
	dev-perl/Date-Calc
	dev-perl/DBI
	dev-perl/IPC-Shareable
	dev-perl/Math-Round
	dev-perl/Net-DNS
	dev-perl/Net-SNPP
	dev-perl/Proc-Queue
	dev-perl/SNMP_Session
	dev-perl/Statistics-Lite
	dev-perl/TimeDate
	dev-perl/Time-ParseDate
	net-analyzer/fping
	<net-analyzer/rrdtool-1.6[perl,graph,rrdcgi]
	virtual/perl-Data-Dumper
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
"

# TODO: sqlite should also be OK here.
REQUIRED_USE='|| ( mysql postgres )'

S="${WORKDIR}/${PN}${PV}"
NMIS_MODDIR="${PN}${PV:0:1}"

pkg_setup() {
	webapp_pkg_setup
}

src_prepare() {
	default

	# Grant freedom to choose DBI driver (read: postgres).
	eapply "${FILESDIR}/${P}-dbi.patch"

	# MRE nmis changes.
	eapply "${FILESDIR}/nmis-mre.patch"

	# replace/drop stupid imports as necessary.
	find . -name '*.p[lm]' \
		-exec sed -i \
		-e 's|^\(use lib "\).*\.\./lib\(";\)|\1'$(perl_get_vendorlib)/${NMIS_MODDIR}'\2|' \
		-e '/use lib "\/usr\/local\/rrdtool\/lib\/perl"/d' \
		'{}' ';'

	# delegate database permissions to user & post-install.
	sed -i \
		-e '/GRANT\|\(CREATE\|DROP\) \(DATABASE\|USER\)\|FLUSH PRIV\|SET PASSWORD/d' \
		install/nmis-event.sql || die 'sed failed to tweak sql'

	if use postgres; then
		sed -i \
			-e '/USE/d' \
			-e 's/`//g' \
			-e 's/tinyint([0-9]\+)/smallint/' \
			-e 's/ENGINE=InnoDB.*;/;/' \
			install/nmis-event.sql || die 'sed failed to tweak sql for postgres'
	fi

	# nmis.conf under install/ is more uptodate than the one under conf/
	mv {install,conf}/nmis.conf || die 'mv failed for nmis.conf'
}

src_install() {
	mv lib $NMIS_MODDIR || die 'mv failed'
	perl_domodule -r $NMIS_MODDIR

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r htdocs/*

	exeinto "${MY_CGIBINDIR}"
	doexe cgi-bin/*

	exeinto "${MY_HOSTROOTDIR}"/bin
	doexe bin/*

	insinto "${MY_HOSTROOTDIR}"
	doins -r conf
	doins -r mibs
	keepdir "${MY_HOSTROOTDIR}"/{error,icons,logs,var,database4/metrics}

	for d in interface health; do
		keepdir "${MY_HOSTROOTDIR}"/database4/"$d"/{generic,Router,server,switch}
	done

	# TODO: Stub, not all files under conf/ should be necessary.
	while read -r -d$'\n' config_file; do
		webapp_configfile "${MY_HOSTROOTDIR}"/"$config_file"
	done < <(find conf -type f)

	# Database creation & sample configuration.
	if use mysql; then
		webapp_sqlscript mysql 'install/nmis-event.sql'
		newdoc install/my.cnf my.cnf.example
	elif use postgres; then
		webapp_sqlscript postgres 'install/nmis-event.sql'
	fi

	# Hook script to tweak permissions for virtual host install.
	webapp_hook_script "${FILESDIR}/reconfig"

	# Postinstall instructions
	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
