# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Apache Arrow and Parquet libraries"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://arrow.apache.org/"
EGIT_REPO_URI="https://github.com/apache/arrow.git"
EGIT_COMMIT="8f5df459c7c77c38730b9543ed96d6d28d9ac64a"
SRC_URI="https://github.com/jemalloc/jemalloc/archive/5.2.0.tar.gz -> jemalloc-5.2.0.tar.gz"
SLOT="0"
DEPEND="dev-libs/boost
		dev-libs/thrift
		dev-libs/rapidjson
		dev-libs/double-conversion
		dev-cpp/gflags
		dev-cpp/glog
		app-arch/zstd
		app-arch/lz4
		app-arch/snappy
		app-arch/brotli"
RDEPEND="${DEPEND}"
S="${WORKDIR}/apache-arrow-${PV}"

CMAKE_BUILD_TYPE="release"
CMAKE_USE_DIR="${S}/cpp"
CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
	export ARROW_JEMALLOC_URL="${DISTDIR}/jemalloc-5.2.0.tar.gz"

	local mycmakeargs=(
		-DARROW_PARQUET=ON
		-DARROW_IPC=OFF
	)

	cmake-utils_src_configure
}
