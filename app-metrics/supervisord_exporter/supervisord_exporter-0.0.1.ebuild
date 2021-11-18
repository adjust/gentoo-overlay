# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
HOMEPAGE="https://github.com/adjust"
DESCRIPTION="Monitor cpu and memory usage by supervisord jobs for Prometheus node_exporter"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

IUSE=""

RDEPEND="
	app-metrics/node_exporter
	dev-python/psutil
"
S=${FILESDIR}
src_install() {
	newinitd "${FILESDIR}"/${PN} ${PN}
	insinto /var/lib/node_exporter
	newins "${FILESDIR}"/${PN}.py "${PN}.py"
	fowners node_exporter:node_exporter /var/lib/node_exporter
	fowners node_exporter:node_exporter /var/lib/node_exporter/${PN}.py
	fperms 0775 /var/lib/node_exporter
	fperms 0550 /var/lib/node_exporter/${PN}.py
}
