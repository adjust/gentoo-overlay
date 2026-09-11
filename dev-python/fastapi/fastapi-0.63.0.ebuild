# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=flit
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="High performance, easy to learn, fast to code, ready for production"
HOMEPAGE="https://fastapi.tiangolo.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	<dev-python/starlette-0.14.1[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
"
