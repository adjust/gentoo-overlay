# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user

DESCRIPTION="A high-throughput distributed messaging system"
HOMEPAGE="http://kafka.apache.org/"

# pick recommended scala version
SCALA_VERSION=2.11
MY_PN="kafka"
MY_P="${MY_PN}_${SCALA_VERSION}-${PV}"
SRC_URI="mirror://apache/kafka/${PV}/${MY_P}.tgz"

RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	|| ( virtual/jre:1.8 virtual/jre:1.7 )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
INSTALL_DIR="/opt/${MY_PN}"

src_prepare() {
	sed -i -e 's:/tmp/zookeeper:/var/kafka/zookeeper:' "config/zookeeper.properties"
	sed -i -e 's:/tmp/kafka-logs:/var/kafka/logs:' "config/server.properties"
}

src_install() {
	insinto /etc/kafka
	doins config/zookeeper.properties config/server.properties

	keepdir /var/kafka/zookeeper

	newinitd "${FILESDIR}/${MY_PN}.init.d" "${MY_PN}"
	newinitd "${FILESDIR}/${MY_PN}-zookeeper.init.d" "${MY_PN}-zookeeper"

	dodir "${INSTALL_DIR}"
	cp -pRP bin config libs "${ED}/${INSTALL_DIR}" || die
}
