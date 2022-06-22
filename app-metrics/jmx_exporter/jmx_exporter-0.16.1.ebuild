# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="A process for exposing JMX Beans via HTTP for Prometheus consumption"
HOMEPAGE="https://github.com/prometheus/jmx_exporter"
SRC_URI="https://bitbucket.org/_x0r/xor-overlay/downloads/jmx_prometheus_httpserver_${PV}_all.deb"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	virtual/jdk
"
DEPEND="
	${RDEPEND}
"

S="${WORKDIR}"

src_install() {

	insinto /usr
	doins -r "${S}"/usr/*

	insinto /etc
	doins -r "${S}"/etc/*

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	fperms +x /usr/bin/${PN} || die "failed to mark /usr/bin/${PN} executable"
}
