# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A concurrent and asynchronous programming library"
HOMEPAGE="https://github.com/apache/mesos/tree/${PV}/3rdparty/libprocess"
SRC_URI="mirror:/apache/mesos/${PV}/mesos-${PV}.tar.gz
	https://raw.githubusercontent.com/apache/mesos/${PV}/3rdparty/${PN}/configure.ac -> ${P}-configure.ac"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

IUSE="libevent"

DEPEND="dev-libs/libev
	dev-cpp/picojson
	dev-libs/rapidjson
	dev-libs/protobuf
	net-libs/grpc
	libevent? ( dev-libs/libevent )
"

MESOS_S="${WORKDIR}"/mesos-${PV}
S="${MESOS_S}"/3rdparty/${PN}

PATCHES=( "${FILESDIR}"/3rdparty_libprocess_include_process_grpc.patch )

src_prepare() {
	default

	cp "${DISTDIR}"/libprocess-1.9.0-configure.ac "${S}"/configure.ac
	cp -r "${MESOS_S}"/m4 "${S}"
	sed -i \
		's@^GMOCKSRC="gmock-all.cc"$@GMOCKSRC="gmock/gmock.h"@' \
		configure.ac

	eautoreconf
}

src_configure() {
	econf \
		--disable-bundled \
		$(use_enable libevent)
}