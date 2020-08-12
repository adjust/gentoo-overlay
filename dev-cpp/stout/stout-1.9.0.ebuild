# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A C++ library for building sturdy software."
HOMEPAGE="https://github.com/apache/mesos/tree/${PV}/3rdparty/stout"
SRC_URI="mirror:/apache/mesos/${PV}/mesos-${PV}.tar.gz
	https://raw.githubusercontent.com/apache/mesos/${PV}/3rdparty/${PN}/configure.ac -> ${P}-configure.ac"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

MESOS_S="${WORKDIR}"/mesos-${PV}
S="${MESOS_S}"/3rdparty/${PN}

src_prepare() {
	cp "${DISTDIR}"/${P}-configure.ac "${S}"/configure.ac
	cp -r "${MESOS_S}"/m4 "${S}"

	sed -i \
		's@^GMOCKSRC="gmock-all.cc"$@GMOCKSRC="gmock/gmock.h"@' \
		configure.ac

	eautoreconf
	default
}

src_configure() {
	econf \
		--disable-bundled
}