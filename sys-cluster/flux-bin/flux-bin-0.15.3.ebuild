# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils user

MY_PN="${PN/-bin/}"

DESCRIPTION="Open and extensible continuous delivery solution for Kubernetes."
HOMEPAGE="https://fluxcd.io/"
SRC_URI="https://github.com/fluxcd/flux2/releases/download/v${PV}/${MY_PN}_${PV}_linux_amd64.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

src_install() {
	dobin "${S}/flux" || die
}
