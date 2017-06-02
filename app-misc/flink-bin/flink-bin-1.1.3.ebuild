# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils user

DESCRIPTION="Scalable Batch and Stream Data Processing"
HOMEPAGE="https://flink.apache.org/"

# pick recommended scala version
SCALA_VERSION=2.10
MY_PN="flink"
MY_P="${MY_PN}-${PV}-bin-hadoop1-scala_${SCALA_VERSION}"
SRC_URI="mirror://apache/flink/flink-${PV}/${MY_P}.tgz"
SLOT=${PV}
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| ( virtual/jre:1.8 )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"
INSTALL_DIR="/opt/${MY_PN}-${PV}"

pkg_setup() {
	enewgroup flink
	enewuser flink -1 /bin/bash /var/lib/flink flink
}

src_install() {
	keepdir /var/lib/flink
	fowners -R flink:flink /var/lib/flink

	dodir "${INSTALL_DIR}"
	cp -pRP ./* "${ED}/${INSTALL_DIR}" || die
	fowners -R flink:flink "${INSTALL_DIR}"

	dosym "${INSTALL_DIR}/bin/flink" "usr/bin/"
}
