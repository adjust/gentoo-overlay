# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A streaming multipart parser for Python"
HOMEPAGE="https://andrew-d.github.io/python-multipart"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
"
