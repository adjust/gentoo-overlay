# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=WHOSGONNA
DIST_VERSION=1.11

inherit perl-module

DESCRIPTION="A small module to eliminate boilerplate overhead when using the Zabbix API"
HOMEPAGE="https://metacpan.org/pod/Zabbix::Tiny"

KEYWORDS="~amd64"
#LICENSE="|| ( Artistic GPL-1+ )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Module-Build-Tiny
"

RDEPEND="
	${DEPEND}
"
