# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit autotools

DESCRIPTION="A Platform for Fine-Grained Resource Sharing in the Data Center"
HOMEPAGE="https://${PN}.apache.org"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	dev-cpp/concurrentqueue
	dev-cpp/elfio
	dev-cpp/glog
	dev-cpp/gtest
	dev-java/maven-bin
	dev-libs/apr
	dev-libs/boost
	dev-libs/cyrus-sasl
	dev-libs/leveldb
	dev-vcs/subversion
	net-libs/http-parser
	virtual/jdk
"

DOCS=( LICENSE NOTICE README.md )

src_prepare() {
	sed -i \
		's@^GMOCKSRC="gmock-all.cc"$@GMOCKSRC="gmock/gmock.h"@' \
		configure.ac
	eautoconf
	default
}

src_configure() {
	econf \
		--disable-bundled \
		--disable-bundled-pip \
		--disable-bundled-setuptools \
		--disable-bundled-wheel \
		--with-boost="${ESYSROOT}"/usr \
		--with-gmock="${ESYSROOT}"/usr \

}
