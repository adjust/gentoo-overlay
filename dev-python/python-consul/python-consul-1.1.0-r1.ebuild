# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Python client for Consul"
HOMEPAGE="https://github.com/cablehead/python-consul/"
SRC_URI="https://github.com/cablehead/python-consul/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	>=dev-python/treq-16[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# needs pytest-twisted
RESTRICT="test"
