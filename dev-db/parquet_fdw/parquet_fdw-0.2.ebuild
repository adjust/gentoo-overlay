# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 10 11 12 13 )

inherit postgres-multi

DESCRIPTION="Parquet foreign data wrapper for PostgreSQL"
HOMEPAGE="https://github.com/adjust/parquet_fdw"
SRC_URI="https://github.com/adjust/parquet_fdw/archive/v${PV}.tar.gz"

LICENSE="POSTGRESQL"
KEYWORDS="~amd64"
SLOT=0

RESTRICT="test" # connects to local DB instance, which is bad

DEPEND="${POSTGRES_DEP}"
RDEPEND="
	${DEPEND}
	dev-db/postgresql
	>=dev-libs/apache-arrow-0.15
"

src_compile() {
	postgres-multi_foreach emake USE_PGXS=1
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
}
