# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

MY_PN="jmx_prometheus_httpserver"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A process for exposing JMX Beans via HTTP for Prometheus consumption"
HOMEPAGE="https://github.com/prometheus/jmx_exporter"
SRC_URI="https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/${PV}/${MY_P}.deb -> ${P}.deb"

LICENSE="Apache-2.0"
KEYWORDS="amd64"

SLOT="0"

RDEPEND="virtual/jdk"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	default
	mv usr/share/jmx_exporter/* usr/share/jmx_exporter/${MY_P}.jar || die
}

src_install() {
	insinto /usr
	doins -r "${S}"/usr/*

	insinto /etc
	doins -r "${S}"/etc/*

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	fperms +x /usr/bin/${PN} || die "failed to mark /usr/bin/${PN} executable"
}
