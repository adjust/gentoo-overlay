# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.6 10 11 12 )

inherit postgres-multi

DESCRIPTION="Useful views and queries for PostgreSQL monitoring"
HOMEPAGE="http://big-elephants.com/pg-telemetry"
SRC_URI="https://api.pgxn.org/dist/pgtelemetry/${PV}/pgtelemetry-${PV}.zip"
LICENSE="POSTGRESQL GPL-2"

KEYWORDS="~amd64"

SLOT=0

RESTRICT="test" # connects to local DB instance, which is bad

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_prepare() {
	cp "${FILESDIR}/Makefile" .
	postgres-multi_src_prepare
}

src_compile() {
	postgres-multi_foreach emake USE_PGXS=1
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
}
