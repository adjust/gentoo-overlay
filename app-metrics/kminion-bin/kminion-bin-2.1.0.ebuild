# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"

DESCRIPTION="KMinion is a feature-rich Prometheus exporter for Apache Kafka written in Go."
HOMEPAGE="https://github.com/cloudhut/kminion"
SRC_URI="https://github.com/cloudhut/kminion/releases/download/v${PV}/${MY_PN}_${PV}_linux_amd64.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND=""

S="${WORKDIR}"

QA_PREBUILT="
	/opt/kminion/kminion
"

src_install() {
	exeinto /opt/${MY_PN}
	doexe "${S}"/kminion
	dosym /opt/${MY_PN}/kminion /usr/bin/kminion
}
