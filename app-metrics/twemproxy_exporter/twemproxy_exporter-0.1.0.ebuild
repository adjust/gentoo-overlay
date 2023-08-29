# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Prometheus exporter that scrapes metrics from a nutcracker"
HOMEPAGE="https://github.com/stuartnelson3/twemproxy_exporter"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/stuartnelson3/twemproxy_exporter.git"
else
	SRC_URI="https://github.com/adjust/gentoo-overlay/releases/download/twemproxy/twemproxy_exporter.tar.gz"
fi
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go"

src_compile() {
		go build -o nutcracker_exporter || die
}

src_install() {
		dobin nutcracker_exporter
		newconfd "${FILESDIR}"/nutcracker_exporter.confd nutcracker_exporter
		newinitd "${FILESDIR}"/nutcracker_exporter.initd nutcracker_exporter
		newconfd "${FILESDIR}"/nutcracker_socket_exporter.confd nutcracker_socket_exporter
		newinitd "${FILESDIR}"/nutcracker_socket_exporter.initd nutcracker_socket_exporter
}
