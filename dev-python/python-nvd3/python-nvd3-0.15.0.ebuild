# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1 pypi

DESCRIPTION="Chart Library for d3.js"
HOMEPAGE="https://pypi.org/project/python-nvd3"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/python-slugify[${PYTHON_USEDEP}]
"
