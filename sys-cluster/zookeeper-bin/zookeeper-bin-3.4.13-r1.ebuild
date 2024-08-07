# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-utils-2

MY_PN="zookeeper"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A high-performance coordination service for distributed applications"
HOMEPAGE="https://zookeeper.apache.org/"
SRC_URI="https://archive.apache.org/dist/${MY_PN}/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror binchecks"

BDEPEND="
	acct-group/zookeeper
	acct-user/zookeeper
"
RDEPEND="
	${BDEPEND}
	>=virtual/jre-1.7
"

INSTALL_DIR=/opt/"${PN}"
export CONFIG_PROTECT="${CONFIG_PROTECT} ${INSTALL_DIR}/conf"

src_prepare() {
	default
	rm "${S}"/docs/images/instruction_arrow.png || die
	rm "${S}"/docs/skin/images/instruction_arrow.png || die
}

src_install() {
	local DATA_DIR=/var/lib/"${MY_P}"

	# cleanup sources
	rm bin/*.cmd || die

	keepdir "${DATA_DIR}"
	sed "s:^dataDir=.*:dataDir=${DATA_DIR}:" conf/zoo_sample.cfg > conf/zoo.cfg || die
	cp "${FILESDIR}"/log4j.properties conf/ || die

	dodir "${INSTALL_DIR}"
	cp -a "${S}"/* "${ED}${INSTALL_DIR}" || die

	# data dir perms
	fowners zookeeper:zookeeper "${DATA_DIR}"

	# log dir
	keepdir /var/log/zookeeper
	fowners zookeeper:zookeeper /var/log/zookeeper

	# init script
	newinitd "${FILESDIR}"/zookeeper.initd zookeeper
	newconfd "${FILESDIR}"/zookeeper.confd zookeeper

	# env file
	cat > 99"${PN}" <<-EOF
		PATH="${INSTALL_DIR}"/bin
		CONFIG_PROTECT="${INSTALL_DIR}"/conf
	EOF
	doenvd 99"${PN}"
}
