# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Apache Thrift"
HOMEPAGE="https://thrift.apache.org/"
SRC_URI="https://archive.apache.org/dist/thrift/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE='test +zlib static-libs glib'

DEPEND="
	dev-libs/boost
	dev-libs/openssl:=
	zlib? ( sys-libs/zlib:= )
	glib? ( dev-libs/glib:2 )
"

RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	test? ( dev-libs/boost[static-libs] )
"

src_configure() {
	#TODO: make useful
	local myeconfargs=(
		--without-csharp
		--without-d
		--without-dart
		--without-dotnetcore
		--without-erlang
		--without-go
		--without-haskell
		--without-haxe
		--without-java
		--without-lua
		--without-qt4
		--without-qt5
		--without-ruby
		--without-nodejs
		--without-rs
		--without-python
		$(use_with glib c_glib)
		$(use_with zlib)
		$(use_enable static-libs static)
		$(use_enable test tests)
	)
	econf "${myeconfargs[@]}"
}
