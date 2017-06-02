# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="5"

inherit kernel-2 eutils
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
GENPATCHES_URI="https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-4.10-5.base.tar.xz https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-4.10-5.extras.tar.xz"
CONFIG_URI="http://files.adjust.com/buildkernel-${PVR}"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CONFIG_URI}"

src_prepare() {
	epatch "${FILESDIR}/bond-mtu.patch"
	kernel-2_src_prepare
}

src_compile() {
	unset ARCH
	cp ${DISTDIR}/buildkernel-${PVR} ${S}/.config
	emake || die
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
