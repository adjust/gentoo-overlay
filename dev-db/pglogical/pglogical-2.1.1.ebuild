# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# 9.4 still has build failure because tarball too difficult
POSTGRES_COMPAT=( 9.5 9.6 10 )
POSTGRES_USEDEP="static-libs"

inherit postgres-multi

DESCRIPTION="logical replication for postgres"
HOMEPAGE="https://www.2ndquadrant.com/en/resources/pglogical/"
# bleh ...
SRC_URI="https://github.com/2ndQuadrant/pglogical/archive/REL2_1_1.zip -> ${P}.zip"

LICENSE="POSTGRESQL"
KEYWORDS="~amd64"

SLOT=0

RESTRICT="test" # connects to local DB instance, which is bad

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/pglogical-REL2_1_1

src_compile() {
	postgres-multi_foreach emake USE_PGXS=1
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
}
