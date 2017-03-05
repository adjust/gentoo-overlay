# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

KEYWORDS="~amd64"
HOMEPAGE="https://github.com/adjust/gentoo-overlay"
IUSE=""
SLOT="${PV}"
LICENSE="GPL-2 freedist"

DESCRIPTION="Prebuilt gentoo kernel image with genkernel initramfs"
SRC_URI="http://files.adjust.com/binkernel-${PV}.tar.xz"

DEPEND=""

S=${WORKDIR}

src_compile() {
	:;
}

src_install() {
	cp -var "${WORKDIR}"/* "${D}"
}
