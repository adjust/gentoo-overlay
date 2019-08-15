# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base user

MY_PN="${PN##prometheus-}"
EGO_PN="github.com/prometheus/${MY_PN}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-lang/go-1.5
	=dev-util/promu-0.3.0
"

EXPORTER_USER=prometheus-exporter

MY_P="${P##prometheus-}"
S="${WORKDIR}/${MY_P}/src/${EGO_PN}"

pkg_setup() {
	enewgroup "${EXPORTER_USER}"
	enewuser "${EXPORTER_USER}" -1 -1 -1 "${EXPORTER_USER}"
}

src_unpack() {
	default
	mkdir -p "temp/src/${EGO_PN%/*}"
	mv "${MY_P}" "temp/src/${EGO_PN}"
	mv temp "${MY_P}"
}

src_prepare() {
	eapply "${FILESDIR}/prometheus-node_exporter-0.18.1-system-promu.patch"
	eapply_user
}

src_compile() {
	export GOPATH="${WORKDIR}/${MY_P}"
	export PREFIX="${S}/${PN}"
	emake build
}

src_install() {
	newbin "${PN}/${MY_PN}" "${PN}"
	dodoc README.md

	keepdir /var/log/${EXPORTER_USER}
	fowners "${EXPORTER_USER}:${EXPORTER_USER}" /var/log/${EXPORTER_USER}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
