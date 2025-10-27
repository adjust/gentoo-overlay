# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Prometheus exporter for Unbound TLS metrics"
HOMEPAGE="https://github.com/letsencrypt/unbound_exporter"
SRC_URI="
	${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://files.adjust.com/${P}.tar.xz -> ${P}-deps.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-user/unbound
	acct-group/unbound
"

DOCS=(README.md)

src_unpack() {
	default
}

src_prepare() {
	default
}

src_compile() {
	ego build -o "${PN}"
}

src_install() {
	dobin "${PN}"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	einstalldocs
}
