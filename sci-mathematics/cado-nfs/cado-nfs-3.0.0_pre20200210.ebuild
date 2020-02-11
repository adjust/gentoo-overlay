# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE="sqlite"


inherit eutils cmake-utils python-r1

DESCRIPTION="Number Field Sieve (NFS) implementation for factoring integers"
HOMEPAGE="http://cado-nfs.gforge.inria.fr/"
SRC_URI="http://gentooexperimental.org/~patrick/${P}.tar"

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

S=${WORKDIR}

src_prepare() {
	# looks like packaging mistake
	sed -i -e 's/add_executable (convert_rels convert_rels.c)//' misc/CMakeLists.txt || die
	sed -i -e 's/target_link_libraries (convert_rels utils)//' misc/CMakeLists.txt || die
	sed -i -e 's~install(TARGETS convert_rels RUNTIME DESTINATION bin/misc)~~' misc/CMakeLists.txt || die

	eapply_user
}

src_configure() {
	export FLAGS_SIZE="-D__SIZEOF_P_R_VALUES__=8"
	DESTINATION="/usr/libexec/cado-nfs" cmake-utils_src_configure
}
src_compile() {
	# autodetection goes confused for gf2x
	ABI=default cmake-utils_src_compile
}
