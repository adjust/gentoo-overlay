# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module
# Project name and version
DESCRIPTION="Keepalived Exporter for Prometheus"
HOMEPAGE="https://github.com/mehdy/keepalived-exporter"
SRC_URI="https://github.com/mehdy/keepalived-exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# Go module dependencies
COMMON_DEPEND="
	>=dev-lang/go-1.22
	acct-group/keepalived-exporter
	acct-user/keepalived-exporter
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
	make dep
	make build
}

src_install() {
	dobin "${PN}"
	newinitd "${FILESDIR}"/"${PN}".initd keepalived-exporter
	newconfd "${FILESDIR}"/"${PN}".confd keepalived-exporter
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

src_test() {
	true
}

