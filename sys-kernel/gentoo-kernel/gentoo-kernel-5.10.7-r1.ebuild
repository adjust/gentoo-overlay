# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

RESTRICT="mirror"

KEYWORDS="~amd64"
HOMEPAGE="https://github.com/adjust/gentoo-overlay"
SLOT="$(ver_cut 1-2)"
LICENSE="GPL-2 freedist"

DESCRIPTION="Prebuilt gentoo kernel image with genkernel initramfs"

SRC_URI="
	protection? (
		https://files.adjust.com/binkernel-hard-${PV}.tar.xz
		sources? (
			https://files.adjust.com/buildkernel-${PV}-hardened
		)
	)
	docker? (
		https://files.adjust.com/binkernel-docker-${PV}.tar.xz
		sources? (
			https://files.adjust.com/buildkernel-${PV}-docker
		)
	)
	!protection? (
		!docker? (
			https://files.adjust.com/binkernel-${PV}.tar.xz
			sources? (
				https://files.adjust.com/buildkernel-${PV}
			)
		)
	)
"

IUSE="sources protection docker"

DEPEND="sources? ( =sys-kernel/gentoo-sources-${PV} )"

REQUIRED_USE="
	protection? ( !docker )
	docker? ( !protection )
"

S=${WORKDIR}

MY_KV="${PV%%-r*}"

src_prepare() {
	default

	mv "${WORKDIR}"/boot/initramfs-genkernel-x86_64-${MY_KV}-gentoo "${WORKDIR}"/boot/initramfs-${MY_KV}-gentoo.img
	mv "${WORKDIR}"/boot/kernel-genkernel-x86_64-${MY_KV}-gentoo "${WORKDIR}"/boot/vmlinuz-${MY_KV}-gentoo
}

src_compile() {
	:;
}

src_install() {
	cp -var "${WORKDIR}"/* "${D}"
	if use sources; then
		mkdir -p "${D}"/usr/src/linux-${PV}-gentoo/
		if use protection; then
			cp "${DISTDIR}/buildkernel-${PV}-hardened" "${D}"/usr/src/linux-${PV}-gentoo/.config
		elif use docker; then
			cp "${DISTDIR}/buildkernel-${PV}-docker" "${D}"/usr/src/linux-${PV}-gentoo/.config
		else
			cp "${DISTDIR}/buildkernel-${PV}" "${D}"/usr/src/linux-${PV}-gentoo/.config;
		fi
		cp "${D}/Module.symvers" "${D}"/usr/src/linux-${PV}-gentoo/Module.symvers
	fi
	rm "${D}"/Module.symvers
}

pkg_postinst() {
	if use sources; then
		unset ARCH
		einfo "Preparing kernel sources"
		cd /usr/src/linux-${PV}-gentoo/ && make -s modules_prepare
	fi
}