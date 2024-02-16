# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DeviceAtlas Validator"
HOMEPAGE="https://adjust.com"
SRC_URI="https://files.adjust.com/${P}.tar.gz"

LICENSE="no-source-code"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dobin ${PN}
}
