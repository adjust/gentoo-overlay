# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN=${PN%-bin}

inherit user

DESCRIPTION="Lightweight Kubernetes."
HOMEPAGE="https://github.com/k3s-io/k3s"
VERSION="${PV}+k3s1"
SRC_URI="https://github.com/k3s-io/${MY_PN}/releases/download/v${VERSION}/${MY_PN} -> ${MY_PN}-linux-amd64"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="*"
RESTRICT="strip"
S="${WORKDIR}"

src_install() {
	dobin k3s-linux-amd64
	dosym k3s-linux-amd64 /usr/bin/k3s
}

