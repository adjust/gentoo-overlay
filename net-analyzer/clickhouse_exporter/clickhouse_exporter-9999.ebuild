# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RESTRICT="test"

EGO_PN="github.com/f1yegor/${PN}"

inherit golang-vcs golang-build

DESCRIPTION="Clickhouse Prometheus Exporter"
HOMEPAGE="https://github.com/f1yegor/clickhouse_exporter"

LICENSE="MIT"
KEYWORDS=""

SLOT="0"

IUSE=""

RDEPEND="
	acct-group/clickhouse_exporter
	acct-user/clickhouse_exporter
"

DEPEND="
	${RDEPEND}
"

EXPORTER_USER=clickhouse_exporter

src_install() {
	newbin clickhouse_exporter "${PN}"
	dodoc "src/${EGO_PN}/README.md"

	keepdir /var/log/"${PN}"
	fowners "${EXPORTER_USER}":"${EXPORTER_USER}" /var/log/"${PN}"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
