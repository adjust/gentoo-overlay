# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 10 11 )

inherit postgres-multi

DESCRIPTION="High-performance time-series aggregation for PostgreSQL "
HOMEPAGE="https://www.pipelinedb.com"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}-13.tar.gz"
LICENSE="POSTGRESQL Apache-2.0"

KEYWORDS="~amd64"

SLOT=0

RESTRICT="test" # dinnae check

DEPEND="${POSTGRES_DEP}
	net-libs/zeromq[static-libs]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${PVR/r/}

src_prepare() {
	postgres-multi_src_prepare
}

src_configure() {
	sed -i -e 's~$(headers_dir)~${D}/$(headers_dir)~g' ../*/Makefile || die
}

src_compile() {
	postgres-multi_foreach emake USE_PGXS=1
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
}
