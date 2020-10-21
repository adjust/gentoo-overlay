# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Centrifugo is a scalable real-time messaging server in language-agnostic way"
HOMEPAGE="https://github.com/centrifugal/centrifugo/"

MY_P="${PN}_${PV}_linux_amd64"
SRC_URI="https://github.com/centrifugal/${PN}/releases/download/v${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""
RESTRICT="test"

S="${WORKDIR}"

src_install() {
	dobin ${PN}
	dodoc README.md
}
