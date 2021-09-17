# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A reverse proxy that provides authentication using Providers to validate accounts by email, domain or group"
HOMEPAGE="https://github.com/oauth2-proxy/oauth2-proxy"
SRC_URI="https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${PV}/${PN}-v${PV}.linux-amd64.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

QA_PREBUILT="
	/opt/oauth2-proxy/oauth2-proxy
"

S="${WORKDIR}"

src_install() {
	exeinto /opt/${PN}
	doexe "${WORKDIR}/${PN}-v${PV}.linux-amd64/oauth2-proxy"
	newinitd "${FILESDIR}/${P}" "${PN}"
}
