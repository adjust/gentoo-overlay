# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.6 10 11 )

inherit postgres-multi cmake

DESCRIPTION="Open-source time-series SQL database"
HOMEPAGE="https://www.timescale.com/"
SRC_URI="https://github.com/timescale/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="POSTGRESQL Apache-2.0 tsl"

KEYWORDS="~amd64"

SLOT=0

RESTRICT="test"

CMAKE_IN_SOURCE_BUILD=yes
CMAKE_BUILD_TYPE="RelWithDebInfo"
BUILD_DIR=${WORKDIR}/${P}

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_prepare() {
	postgres-multi_src_prepare
	postgres-multi_foreach cmake_src_prepare
}
