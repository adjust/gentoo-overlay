# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base user

EGO_PN="github.com/go-graphite/carbonapi"
SRC_URI="https://${EGO_PN}/archive/refs/tags/${PV}.zip -> ${P}.zip"
KEYWORDS="~amd64"

DESCRIPTION="Implementation of graphite API (graphite-web) in golang"
HOMEPAGE="https://github.com/go-graphite/carbonapi"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-lang/go-1.5
"

CARBON_USER="carbon"

pkg_setup() {
	enewgroup "${CARBON_USER}"
	enewuser "${CARBON_USER}" -1 -1 "/var/lib/graphite" "${CARBON_USER}"
}

src_compile() {
	export BUILD="${PV}"
	emake
}

src_install() {
	dobin "${PN}"
	dodoc README.md

	keepdir /var/log/${PN} /etc/${PN}
	fowners "${CARBON_USER}:${CARBON_USER}" /var/log/${PN}

	insinto /etc/${PN}
	doins "${FILESDIR}"/carbonapi.example.yaml

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
