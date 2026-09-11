# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="This is an unofficial Python API for Bamboo HR."
HOMEPAGE="https://pypi.org/project/PyBambooHR/"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

DEPEND="
	dev-python/httpretty[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
"
