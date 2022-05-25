# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.6 10 11 12 )

inherit postgres-multi

DESCRIPTION="Currency enum type in one byte"
HOMEPAGE="https://github.com/adjust/pg-currency"
SRC_URI="https://api.pgxn.org/dist/currency/${PV}/currency-${PV}.zip"
LICENSE="POSTGRESQL GPL-2"

KEYWORDS="~amd64"

SLOT=0

RESTRICT="test" # connects to local DB instance, which is bad

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_compile() {
	postgres-multi_foreach emake USE_PGXS=1
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
}
