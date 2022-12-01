# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A useful set of utilities for interacting with a cloud."
HOMEPAGE="https://github.com/canonical/cloud-utils"
SRC_URI="https://github.com/canonical/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
PYTHON_COMPAT=( python3_{8..11} )

inherit python-r1

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

PATCHES=( "${FILESDIR}/${P}-xorriso.patch" )

RDEPEND="
	${PYTHON_DEPS}
	sys-fs/dosfstools
	dev-libs/libisoburn
	sys-fs/lvm2
	app-emulation/qemu
	app-arch/gzip
	net-misc/wget
	sys-apps/util-linux
	sys-fs/udev
"

src_install() {
	einstalldocs

	python_foreach_impl python_doscript bin/ec2metadata
	python_foreach_impl python_doscript bin/write-mime-multipart

	dobin bin/cloud-localds
	dobin bin/growpart
	dobin bin/mount-image-callback
	dobin bin/resize-part-image

	doman man/*.1
}
