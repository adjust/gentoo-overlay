# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..13} )

inherit distutils-r1

DESCRIPTION="Agent to send system information to netbox"
HOMEPAGE="https://github.com/Solvik/netbox-agent"
SRC_URI="https://github.com/Solvik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

REQUIRED_USE=${PYTHON_REQUIRED_USE}
RDEPEND="
	${PYTHON_DEPS}
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/netifaces2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/python-slugify[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]

	dev-python/jsonargparse[${PYTHON_USEDEP}]
	dev-python/pynetbox[${PYTHON_USEDEP}]
"
BDEPEND=${RDEPEND}

PATCHES=(
	"${FILESDIR}/001-fix-exit-code.patch"
)

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
