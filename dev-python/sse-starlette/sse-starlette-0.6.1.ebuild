# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Server Sent Events for Starlette"
HOMEPAGE="https://pypi.org/project/sse-starlette/"

LICENSE="BSD"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"
