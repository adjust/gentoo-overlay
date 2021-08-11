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

IUSE="brotli deprecated glog lz4 parquet snappy static-libs zlib zstd"

DEPEND="
	dev-libs/boost:=
	dev-libs/thrift:=
	|| (
		dev-libs/rapidjson
		sys-cluster/mesos
	)
	dev-libs/double-conversion:=
	dev-cpp/gflags:=
	glog? ( dev-cpp/glog:= )
	brotli? ( app-arch/brotli )
	lz4? ( app-arch/lz4 )
	snappy? ( app-arch/snappy )
	zlib? ( sys-libs/zlib:= )
	zstd? ( app-arch/zstd )
	dev-libs/openssl:=
"

RDEPEND="
	${DEPEND}
"

# Testing requires files from https://github.com/apache/parquet-testing
RESTRICT="test"

S="${WORKDIR}/arrow-apache-arrow-${PV}"

CMAKE_BUILD_TYPE="release"
CMAKE_USE_DIR="${S}/cpp"
CMAKE_MAKEFILE_GENERATOR="emake"

# - Arrow forces bundled jemalloc == disable
# - ARROW_IPC requires Flatbuffers, which results in build errors due to
#   broken find_program calls for flatc == disable
src_configure() {
	local mycmakeargs=(
		-DARROW_ALTIVEC=OFF
		-DARROW_BUILD_STATIC="$(usex static-libs)"
		-DARROW_IPC=OFF
		-DARROW_JEMALLOC=OFF
		-DARROW_NO_DEPRECATED_API="$(usex !deprecated)"
		-DARROW_PARQUET="$(usex parquet)"
		-DARROW_USE_GLOG="$(usex glog)"
		-DARROW_VERBOSE_THIRDPARTY_BUILD=OFF
		-DARROW_WITH_BROTLI="$(usex brotli)"
		-DARROW_WITH_LZ4="$(usex lz4)"
		-DARROW_WITH_SNAPPY="$(usex snappy)"
		-DARROW_WITH_ZLIB="$(usex zlib)"
		-DARROW_WITH_ZSTD="$(usex zstd)"
	)

	cmake_src_configure
}
