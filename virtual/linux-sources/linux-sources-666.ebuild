# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for Linux kernel sources"

KEYWORDS="amd64"

SLOT="0"

IUSE="firmware"

RDEPEND="
	firmware? ( sys-kernel/linux-firmware )
	|| (
		sys-kernel/debian-sources
		sys-kernel/vanilla-sources
		sys-kernel/git-sources
		sys-kernel/mips-sources
		sys-kernel/pf-sources
		sys-kernel/rt-sources
		sys-kernel/zen-sources
		sys-kernel/raspberrypi-sources
		sys-kernel/vanilla-kernel
	)
"
