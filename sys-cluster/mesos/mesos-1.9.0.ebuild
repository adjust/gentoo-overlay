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

# TODO: USE, read through output of configure
# configure: WARNING: libev found must have been built with -DEV_CHILD_ENABLE=0

DEPEND="
	dev-cpp/concurrentqueue
	dev-cpp/elfio
	dev-cpp/glog
	dev-cpp/gtest
	dev-cpp/picojson
	dev-java/maven-bin
	dev-java/protobuf-java
	dev-libs/apr
	dev-libs/boost
	dev-libs/cyrus-sasl
	dev-libs/leveldb
	dev-libs/protobuf
	dev-libs/rapidjson
	dev-vcs/subversion
	net-libs/http-parser
	virtual/jdk
	dev-python/protobuf-python[python_targets_python2_7]
	dev-libs/zookeeper-c
	sys-devel/automake:1.13

"

DOCS=( LICENSE NOTICE README.md )

src_unpack() {
	default
	unpack "${S}"/3rdparty/nvml-352.79.tar.gz
}

src_prepare() {
	sed -i \
		-e 's@^GMOCKSRC="gmock-all.cc"$@GMOCKSRC="gmock/gmock.h"@' \
		configure.ac
	sed -i \
		-e 's/^\(SUBDIRS = . stout\) libprocess$/\1/' \
		3rdparty/Makefile.am
	export PROTOBUF_JAR="/usr/share/protobuf-java/lib/protobuf.jar"
	eautoconf
	default
}

src_configure() {
	export PYTHON="${ESYSROOT}"/usr/bin/python2.7
	econf \
		--disable-bundled \
		--with-boost="${ESYSROOT}"/usr \
		--with-gmock="${ESYSROOT}"/usr \
		--with-nvml="${WORKDIR}"/nvml-352.79 \

}
