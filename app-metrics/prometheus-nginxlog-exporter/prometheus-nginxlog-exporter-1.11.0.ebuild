# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# Project name and version
DESCRIPTION="Prometheus NGINX log exporter"
HOMEPAGE="https://github.com/martin-helmich/prometheus-nginxlog-exporter"
SRC_URI="
		${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://files.adjust.com/${P}.tar.xz -> ${P}-deps.tar.xz
"

LICENSE="Apache-2.0 license"
KEYWORDS="~amd64"
SLOT="0"
IUSE="doc"

DEPEND="
	acct-group/nginx
	acct-user/nginx
	>=dev-lang/go-1.20
"

RDEPEND="${DEPEND}"
SRC_DIR="${WORKDIR}/${P}"

RESTRICT="network-sandbox"

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

src_test() {
	cd "${SRC_DIR}"
	go test -v ./...
}

src_install() {
	dobin "${PN}"

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	dosym /etc/init.d/${PN} /etc/runlevels/default/${PN}

	insinto /etc/${PN}
	doins "${FILESDIR}/config.hcl"

	# Create log directory and file
	keepdir /var/log/${PN}

	# Change ownership of the log file to nginx:nginx
	fowners ${PROMETHEUS_NGINXLOG_EXPORTER_USER:-nginx}:${PROMETHEUS_NGINXLOG_EXPORTER_USER:-nginx} /var/log/${PN}
	fowners ${PROMETHEUS_NGINXLOG_EXPORTER_USER:-nginx}:${PROMETHEUS_NGINXLOG_EXPORTER_USER:-nginx} /etc/${PN}/config.hcl
}
