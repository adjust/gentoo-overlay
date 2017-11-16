# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.5 9.6 10 )

inherit postgres-multi

DESCRIPTION="One-byte enum for major languages"
HOMEPAGE="https://github.com/adjust/pg-language"
SRC_URI="https://api.pgxn.org/dist/language/${PV}/language-${PV}.zip"
LICENSE="POSTGRESQL GPL-2"

KEYWORDS="~amd64"

RESTRICT="test"

SLOT=0

src_compile() {
	postgres-multi_foreach emake USE_PGXS=1
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
}
