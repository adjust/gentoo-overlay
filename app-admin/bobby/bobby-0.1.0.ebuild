# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10,11,12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Interactive assistant for NVMe disk replacement and mdadm RAID management"
HOMEPAGE="https://github.com/adjust/bobby"
SRC_URI="https://github.com/adjust/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="fetch"

# Runtime tools bobby shells out to.
# storcli (MegaSAS controller management) is proprietary and not in the tree;
# install it manually from the vendor if using the hwctrl-migrate step.
RDEPEND="
	sys-fs/mdadm
	sys-apps/nvme-cli
	sys-apps/smartmontools
	sys-block/parted
	sys-apps/util-linux
	sys-process/psmisc
	sys-process/lsof
"

pkg_nofetch() {
	einfo "The bobby source tarball must be downloaded manually."
	einfo "Visit the repository and download the archive for v${PV}:"
	einfo ""
	einfo "  https://github.com/adjust/${PN}/archive/v${PV}.tar.gz"
	einfo ""
	einfo "Save the file as '${P}.tar.gz' and place it in your distfiles directory:"
	einfo ""
	einfo "  ${DISTDIR}/${P}.tar.gz"
}

#distutils_enable_tests pytest
