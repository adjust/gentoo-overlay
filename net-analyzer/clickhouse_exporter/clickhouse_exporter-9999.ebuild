# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RESTRICT="test"

EGO_PN="github.com/f1yegor/${PN}"

inherit golang-vcs golang-build user

DESCRIPTION="Clickhouse Prometheus Exporter"
HOMEPAGE="https://github.com/f1yegor/clickhouse_exporter"
LICENSE="MIT"
SLOT="0"
IUSE=""

EXPORTER_USER=clickhouse_exporter

pkg_setup() {
	enewuser "${EXPORTER_USER}" -1 -1 -1
}

src_install() {
	newbin clickhouse_exporter "${PN}"
	dodoc "src/${EGO_PN}/README.md"

	keepdir /var/log/"${PN}"
	fowners "${EXPORTER_USER}":"${EXPORTER_USER}" /var/log/"${PN}"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
