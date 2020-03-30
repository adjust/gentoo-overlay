# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base golang-vcs golang-build user

DESCRIPTION="statsd_exporter receives StatsD metrics and exports them as Prometheus metrics"
HOMEPAGE="https://prometheus.io"
EGO_PN="github.com/prometheus/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/go-1.5"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup statsd_exporter
	enewuser statsd_exporter -1 -1 -1 statsd_exporter
}

src_install() {
	dobin statsd_exporter
	newinitd "${FILESDIR}/${PN}.initd-r1" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-r1" "${PN}"
	diropts -o statsd_exporter -g statsd_exporter -m 0750
	keepdir /var/log/statsd_exporter
}
