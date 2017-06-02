# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

KEYWORDS="~amd64"
HOMEPAGE="http://www.gentoo.org"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

DESCRIPTION="Autogenerate kernel images with genkernel"
SRC_URI="http://files.adjust.com/${PF}"

DEPEND="
	=sys-kernel/gentoo-sources-${PVR}
	|| (
		sys-kernel/genkernel
		sys-kernel/genkernel-next
	)
	sys-apps/fakeroot
	"

src_unpack() {
	mkdir -p "$S"
}

src_prepare() {
	mkdir -p "$S/tmp/kernel"
	mkdir -p "$S/final/boot"
	mkdir -p "$S/cache"
}

src_compile() {
	# genkernel doesn't know how to kernel
	cp "${DISTDIR}/${A}" "$S/tmp/kernel/.config" || die

	# goddamnit portage stop polluting the environment
	unset ARCH
	export KBUILD_OUTPUT="$S/tmp/kernel"

	# make runs from src dir with output going to KBUILD_OUTPUT
	# FIXME: Ignores PVR here
	cd /usr/src/linux-${PV}-gentoo || die
	make -s oldconfig || die
	echo "Building kernel ..."
	make -s ${MAKEOPTS} || die
	echo "Done building kernel."
	cp "$S/tmp/kernel/arch/x86/boot/bzImage" "$S/final/boot/kernel-genkernel-x86_64-${PVR}-gentoo" || die

	# install  modules to a prefix. Strip in kbuild because otherwise size is >10x more for tarball
	emake INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH="$S/final" modules_install || die

	# busybox uses this internally
	unset KBUILD_OUTPUT
	# we need fakeroot so we can always generate devicenodes like /dev/console
	# this will fail for -rN kernel revisions as kerneldir is hardcoded badly
	fakeroot genkernel initramfs --no-mountboot --bootdir="$S/final/boot" \
		--logfile="$S/genkernel.log"  \
		--tempdir="$S/tmp" \
		--module-prefix="$S/final" \
		--kerneldir=/usr/src/linux-${PVR}-gentoo \
		--mdadm \
		--no-zfs --no-btrfs \
		--kernel-config="$S/tmp/kernel/.config" \
		--cachedir="$S/cache" || die
}

src_install() {
	# don't package firmware files, provided by linux-firmware if required
	rm -rf "$S/final/lib/firmware" || die
	cd "$S/final/" && tar cJf binkernel-${PVR}.tar.xz * || die
	mkdir -p "${D}/usr/share"
	mv binkernel-${PVR}.tar.xz "${D}/usr/share" || die
}
