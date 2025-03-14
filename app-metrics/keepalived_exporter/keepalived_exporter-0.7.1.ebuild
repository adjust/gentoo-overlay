# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module
# Project name and version
DESCRIPTION="Keepalived Exporter for Prometheus"
HOMEPAGE="https://github.com/gen2brain/keepalived_exporter"
SRC_URI="
	https://github.com/gen2brain/keepalived_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://files.adjust.com/${P}.tar.xz -> ${P}-deps.tar.xz
"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# Go module dependencies
COMMON_DEPEND="
	>=dev-lang/go-1.21
	acct-group/keepalived_exporter
	acct-user/keepalived_exporter
"
RDEPEND="${COMMON_DEPEND}"
SRC_DIR="${WORKDIR}/${P}"

src_unpack() {
	default
}

src_prepare() {
	default
}

src_compile() {
	export GOPATH="${SRC_DIR}"
	cd "${SRC_DIR}"
	ego build
}

src_install() {
	dobin "${PN}"
	newinitd "${FILESDIR}"/"${PN}".initd keepalived_exporter
	newconfd "${FILESDIR}"/"${PN}".confd keepalived_exporter
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

src_test() {
	true
}

