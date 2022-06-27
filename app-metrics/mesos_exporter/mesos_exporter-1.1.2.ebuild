# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Exporter for Mesos master and agent metrics."
HOMEPAGE="https://github.com/mesos/mesos_exporter"
SRC_URI="https://github.com/mesos/mesos_exporter/releases/download/v${PV}/${PN}-${PV}.linux-amd64.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

S="${WORKDIR}"

QA_PREBUILT="
	/opt/${PN}
"

src_install() {

    exeinto /opt/${PN}
    doexe "${S}"/${PN}
    dosym /opt/${PN}/${PN} /usr/bin/${PN}
}
