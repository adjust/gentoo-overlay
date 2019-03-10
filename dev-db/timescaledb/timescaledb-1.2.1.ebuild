# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.6 10 11 )

inherit postgres-multi cmake-utils

DESCRIPTION="Open-source time-series SQL database"
HOMEPAGE="https://www.timescale.com/"
SRC_URI="https://github.com/timescale/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="POSTGRESQL Apache-2.0 tsl"

KEYWORDS="~amd64"

SLOT=0

RESTRICT="test"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_prepare() {
	postgres-multi_src_prepare
}
