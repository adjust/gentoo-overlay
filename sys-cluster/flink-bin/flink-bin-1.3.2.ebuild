# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils user

DESCRIPTION="Scalable Batch and Stream Data Processing"
HOMEPAGE="https://flink.apache.org"
SRC_URI="mirror://apache/flink/flink-${PV}/flink-${PV}-bin-hadoop2-scala_2.11.tgz -> ${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/jre:1.8
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/flink-${PV}"

DOCS=( NOTICE README.txt )

pkg_setup() {
	enewgroup flink
	enewuser flink -1 -1 /var/lib/flink flink
}

src_install() {
	dodir usr/lib/flink
	into usr/lib/flink
	insinto usr/lib/flink

	dobin bin/*
	doins -r conf examples lib opt resources tools
	dosym "${ED}"/usr/lib/flink/bin/flink /usr/bin/flink

	keepdir /var/log/flink /etc/flink
	fowners -R flink:flink /var/log/flink

	newinitd "${FILESDIR}"/flink.initd flink
	newconfd "${FILESDIR}"/flink.confd flink
	doenvd "${FILESDIR}"/99flink
	einstalldocs

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/flink.logrotate flink
}
