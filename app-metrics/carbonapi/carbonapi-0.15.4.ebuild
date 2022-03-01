# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base

EGO_PN="github.com/go-graphite/carbonapi"
SRC_URI="https://${EGO_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Implementation of graphite API (graphite-web) in golang"
HOMEPAGE="https://github.com/go-graphite/carbonapi"
LICENSE="MIT"
SLOT="0"
IUSE="nocairo"

RDEPEND="
	acct-group/carbon
	acct-user/carbon

	>=dev-lang/go-1.5
"

src_compile() {
	export BUILD="${PV}"
	use nocairo || emake
	use nocairo && emake nocairo
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
