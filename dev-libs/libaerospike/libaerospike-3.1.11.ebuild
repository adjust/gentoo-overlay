# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/aerospike/aerospike-client-c.git"

inherit autotools git-2

DESCRIPTION="Aerospike C Client"
HOMEPAGE="https://github.com/aerospike/aerospike-client-c"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="luajit +static-libs"

S="${WORKDIR}/aerospike-client-c-${PV}"

# tests fails to build ?
RESTRICT="test"

RDEPEND=">=dev-lang/lua-5.1.5:*
	>=dev-libs/openssl-1.0.1g:=
	dev-vcs/git
	luajit? ( >=dev-lang/luajit-2.0.3:* )"
DEPEND="${RDEPEND}"

src_prepare() {
	#TODO: still using bundled libs, that sucks
	#sed -e 's/^USE_LUAMOD = 1/USE_LUAMOD = 0/g' -i Makefile

	# luajit USE
	use luajit && sed -e 's/^USE_LUAJIT = 0/USE_LUAJIT = 1/g' -i Makefile

	git submodule update --init
}

src_compile() {
	# forced MAKEOPTS, see:
	# https://github.com/aerospike/aerospike-client-c/issues/22
	CC=$(tc-getCC) LD=$(tc-getCC) MAKEOPTS="-j1" emake all
}

src_install() {
	dolib target/Linux-x86_64/lib/libaerospike.so
	use static-libs && dolib.a target/Linux-x86_64/lib/libaerospike.a

	insinto /usr/include/
	doins -r target/Linux-x86_64/include/{aerospike,citrusleaf,ck}

	insinto /opt/aerospike/client/sys/udf/lua/
	doins modules/lua-core/src/{aerospike,as,stream_ops}.lua
}
