# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"

DESCRIPTION="NGINX Prometheus exporter makes it possible to monitor NGINX or NGINX Plus using Prometheus."
HOMEPAGE="https://github.com/nginxinc/nginx-prometheus-exporter"
SRC_URI="https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v${PV}/${MY_PN}_${PV}_linux_amd64.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND="
	dev-lang/go
"

S="${WORKDIR}"

QA_PREBUILT="
	/opt/nginx-prometheus-exporter/nginx-prometheus-exporter
"

src_install() {

	exeinto /opt/${MY_PN}
	doexe "${S}"/nginx-prometheus-exporter
	dosym /opt/${MY_PN}/nginx-prometheus-exporter /usr/bin/nginx-prometheus-exporter
	newinitd "${FILESDIR}"/nginx-prometheus-exporter.init nginx-prometheus-exporter

}

