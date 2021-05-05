# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-r1

DESCRIPTION="High performance, easy to learn, fast to code, ready for production"
HOMEPAGE="https://pypi.org/project/fastapi/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
"
