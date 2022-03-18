# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"

DESCRIPTION="Cluster API is a Kubernetes sub-project focused on providing declarative APIs and tooling to simplify provisioning, upgrading, and operating multiple Kubernetes clusters."
HOMEPAGE="https://github.com/kubernetes-sigs/cluster-api"
SRC_URI="https://github.com/kubernetes-sigs/cluster-api/releases/download/v${PV}/${MY_PN}-linux-amd64 -> ${P}"

LICENSE="MPL-2.0"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND=""

S="${WORKDIR}"

QA_PREBUILT="
	/opt/clusterctl/clusterctl
"

src_unpack(){
    cp ../distdir/${P} clusterctl
}

src_install() {
	exeinto /opt/${MY_PN}
	doexe "${WORKDIR}/clusterctl"
	dosym /opt/${MY_PN}/clusterctl /usr/bin/clusterctl
}
