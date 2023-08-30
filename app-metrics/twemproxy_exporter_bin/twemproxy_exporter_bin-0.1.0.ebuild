# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Prometheus exporter that scrapes metrics from a nutcracker"
HOMEPAGE="https://github.com/stuartnelson3/twemproxy_exporter"
SRC_URI="https://github.com/adjust/gentoo-overlay/releases/download/twemproxy/twemproxy_exporter_bin-0.1.0.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go"

src_install() {
		dobin nutcracker_exporter
		newconfd "${FILESDIR}"/nutcracker_exporter.confd nutcracker_exporter
		newinitd "${FILESDIR}"/nutcracker_exporter.initd nutcracker_exporter
		newconfd "${FILESDIR}"/nutcracker_socket_exporter.confd nutcracker_socket_exporter
		newinitd "${FILESDIR}"/nutcracker_socket_exporter.initd nutcracker_socket_exporter
}
