# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-2

DESCRIPTION="Go extension manager"
HOMEPAGE="https://github.com/adjust/goem"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/goem.git"

LICENSE="BEER-WARE"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/go"

RDEPEND="${DEPEND}"

src_compile() {
	go build -o "${T}/$PN" || die "$!"
}

src_install() {
	dobin "${T}/${PN}"
}
