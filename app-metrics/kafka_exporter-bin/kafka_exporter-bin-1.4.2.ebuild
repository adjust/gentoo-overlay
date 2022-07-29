# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"

DESCRIPTION="Kafka exporter for Prometheus"
HOMEPAGE="https://github.com/danielqsj/kafka_exporter"
SRC_URI="https://github.com/danielqsj/kafka_exporter/releases/download/v${PV}/${MY_PN}-${PV}.linux-amd64.tar.gz -> ${P}.tar.gz"

LICENSE="Apache License 2.0"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND=""

S="${WORKDIR}"

QA_PREBUILT="
	/opt/kafka_exporter/${MY_PN}-${PV}.linux-amd64/kafka_exporter
"

src_install() {
	exeinto /opt/kafka_exporter/${MY_PN}-${PV}.linux-amd64
	doexe "${S}"/${MY_PN}-${PV}.linux-amd64/kafka_exporter
	dosym /opt/kafka_exporter/${MY_PN}-${PV}.linux-amd64/kafka_exporter /usr/bin/kafka_exporter
	keepdir /var/log/${MY_PN}

	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
	newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
}

