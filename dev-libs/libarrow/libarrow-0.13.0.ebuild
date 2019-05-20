EAPI=7
inherit eutils cmake-utils 

ARROW_VSN="0.13.0"
DESCRIPTION="Apache Arrow & Parquet libraries"
HOMEPAGE="https://arrow.apache.org/"
SRC_URI="https://github.com/apache/arrow/archive/apache-arrow-${ARROW_VSN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/arrow-apache-arrow-${ARROW_VSN}/cpp"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# tests fails to build ?
RESTRICT="test"

RDEPEND=">=dev-libs/boost-1.48"
DEPEND=">=dev-util/cmake-3.2 >=dev-libs/boost-1.48"

CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="emake"
BUILD_DIR="${S}/release" 

src_configure() { 
	mkdir ${BUILD_DIR} 
	cd ${BUILD_DIR} 

	local mycmakeargs=( 
		-DARROW_PARQUET=ON
	) 

	cmake-utils_src_configure 
} 

src_compile() { 
   cd ${BUILD_DIR} 
   emake parquet arrow
}

