# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.6 10 11 12 )

inherit postgres-multi

DESCRIPTION="Look up IP address info from MaxMind MMDB files"
HOMEPAGE="http://big-elephants.com/pg-geoip2lookup"
SRC_URI="https://api.pgxn.org/dist/${PN}/${PV}/${P}.zip"

LICENSE="POSTGRESQL GPL-2"
KEYWORDS="~amd64"

SLOT=0

RESTRICT="test" # connects to local DB instance, which is bad

DEPEND="
	${POSTGRES_DEP}
"

RDEPEND="
	${DEPEND}
	dev-db/postgresql[perl]
	dev-perl/MaxMind-DB-Reader
	dev-perl/MaxMind-DB-Reader-XS
"

src_prepare() {
	postgres-multi_src_prepare
}

src_compile() {
	postgres-multi_foreach emake
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install
}
