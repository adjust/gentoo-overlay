# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="sqlite"

inherit eutils cmake-utils python-r1

DESCRIPTION="Number Field Sieve (NFS) implementation for factoring integers"
HOMEPAGE="http://cado-nfs.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/37058/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Fails F9_{k,m}bucket_test F9_tracektest
RESTRICT="test"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/gmp:0=
	dev-lang/perl
	!sci-mathematics/ggnfs
	!sci-biology/shrimp
	"
DEPEND="${RDEPEND}
	"

src_prepare() {
	# looks like packaging mistake
	sed -i -e 's/add_executable (convert_rels convert_rels.c)//' misc/CMakeLists.txt || die
	sed -i -e 's/target_link_libraries (convert_rels utils)//' misc/CMakeLists.txt || die
	sed -i -e 's~install(TARGETS convert_rels RUNTIME DESTINATION bin/misc)~~' misc/CMakeLists.txt || die
}

src_configure() {
	DESTINATION="/usr/libexec/cado-nfs" cmake-utils_src_configure
}
src_compile() {
	# autodetection goes confused for gf2x
	ABI=default cmake-utils_src_compile
}
