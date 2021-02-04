# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Apache Arrow and Parquet libraries"
HOMEPAGE="https://arrow.apache.org"
SRC_URI="https://github.com/apache/arrow/archive/apache-arrow-${PV}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="dev-libs/boost
	dev-libs/thrift
	|| (
		dev-libs/rapidjson
		sys-cluster/mesos
	)
	dev-libs/double-conversion
	dev-libs/jemalloc
	dev-cpp/gflags
	dev-cpp/glog
	app-arch/zstd
	app-arch/lz4
	app-arch/snappy
	app-arch/brotli
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/arrow-apache-arrow-${PV}"

CMAKE_BUILD_TYPE="release"
CMAKE_USE_DIR="${S}/cpp"
CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
	local mycmakeargs=(
		-DARROW_PARQUET=ON
		-DARROW_JEMALLOC=OFF
		-DARROW_WITH_BROTLI=ON
		-DARROW_WITH_LZ4=ON
		-DARROW_WITH_SNAPPY=ON
		-DARROW_WITH_ZLIB=ON
		-DARROW_WITH_ZSTD=ON
	)

	cmake_src_configure
}
