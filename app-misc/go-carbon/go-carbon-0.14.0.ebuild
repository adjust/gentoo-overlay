# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base user

EGO_PN="github.com/lomik/go-carbon"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="carbon-cache replacement written in go"
HOMEPAGE="https://github.com/lomik/go-carbon"
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

	keepdir /var/log/${CARBON_USER} /etc/${PN}
	fowners "${CARBON_USER}:${CARBON_USER}" /var/log/${CARBON_USER}

	insinto /etc/${PN}
	doins "${FILESDIR}"/go-carbon.conf "${FILESDIR}"/storage-schemas.conf

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
