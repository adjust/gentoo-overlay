# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGIT_COMMIT=6f7e6de674d3b7d412a5960b7d2e849e40c1d76b

DESCRIPTION="Prometheus exporter for PgBouncer. Exports metrics at 9127/metrics"
HOMEPAGE="https://github.com/prometheus-community/pgbouncer_exporter"
SRC_URI="https://github.com/prometheus-community/${PN}/releases/download/v${PV}/${PN}-${PV}.linux-amd64.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="
    dev-db/pgbouncer
    acct-user/pgbouncer"
DEPEND="${RDEPEND}"
RESTRICT+=" test"
S="${S}.linux-amd64"

src_install() {
    dobin pgbouncer_exporter
    dodoc LICENSE
    newinitd "${FILESDIR}"/${PN}.initd ${PN}
    newconfd "${FILESDIR}"/${PN}.confd ${PN}
    keepdir "/var/log/${PN}"
    fowners "pgbouncer:postgres" "/var/log/${PN}"
}
