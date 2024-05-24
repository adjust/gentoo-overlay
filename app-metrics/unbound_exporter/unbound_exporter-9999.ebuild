# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd git-r3

DESCRIPTION="Prometheus exporter for PostgreSQL metrics"
HOMEPAGE="https://github.com/letsencrypt/unbound_exporter"
EGIT_REPO_URI="https://github.com/letsencrypt/unbound_exporter"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	acct-user/prometheus
	acct-group/prometheus
"
DOCS=(README.md)

src_unpack() {
	default
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	ego build -o "${PN}"
}

src_install() {
	dobin "${PN}"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"

	einstalldocs
}
