# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base user systemd

SRC_URI="https://github.com/aerospike/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Aerospike Prometheus Exporter"
HOMEPAGE="https://github.com/aerospike/aerospike-prometheus-exporter/"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.12"

EXPORTER_USER=prometheus-exporter

MY_P="${P##prometheus-}"
S="${WORKDIR}/${MY_P}/src/${EGO_PN}"

pkg_setup() {
	enewuser "${EXPORTER_USER}" -1 -1 -1
}

src_unpack() {
	default
	mkdir -p "temp/src/${EGO_PN%/*}"
	mv "${MY_P}" "temp/src/${EGO_PN}"
	mv temp "${MY_P}"
}

src_compile() {
	export GOPATH="${WORKDIR}/${MY_P}"
	export PREFIX="${S}/${PN}"
	emake "${MY_PN}"
}

src_install() {
	newbin "${MY_PN}" "${PN}"
	dodoc README.md

	keepdir /var/lib/prometheus/"${MY_PN}" /var/log/prometheus
	fowners "${EXPORTER_USER}" /var/lib/prometheus/"${MY_PN}" /var/log/prometheus

	insinto /etc/prometheus

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"


        insinto /etc/aerospike-prometheus-exporter/
	newins "${FILESDIR}/ape.toml" "ape.toml"
       
}
