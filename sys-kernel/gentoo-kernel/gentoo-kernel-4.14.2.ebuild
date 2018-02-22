# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

KEYWORDS="~amd64"
HOMEPAGE="https://github.com/adjust/gentoo-overlay"
IUSE=""
SLOT="${PV}"
LICENSE="GPL-2 freedist"

DESCRIPTION="Prebuilt gentoo kernel image with genkernel initramfs"
SRC_URI="https://files.adjust.com/binkernel-${PV}.tar.xz
	sources? (
		https://files.adjust.com/buildkernel-${PV}
		https://files.adjust.com/Module.symvers-${PV}
	)"

IUSE="sources"

DEPEND="sources? ( =sys-kernel/gentoo-sources-${PV} )"

S=${WORKDIR}

src_compile() {
	:;
}

src_install() {
	cp -var "${WORKDIR}"/* "${D}"
	if use sources; then
		mkdir -p "${D}"/usr/src/linux-${PV}-gentoo/
		cp "${DISTDIR}/buildkernel-${PV}" "${D}"/usr/src/linux-${PV}-gentoo/.config
		cp "${DISTDIR}/Module.symvers-${PV}" "${D}"/usr/src/linux-${PV}-gentoo/Module.symvers
	fi
}

pkg_postinst() {
	if use sources; then
		unset ARCH
		einfo "Preparing kernel sources"
		cd /usr/src/linux-${PV}-gentoo/ && make -s modules_prepare
	fi
}
