# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="A streaming multipart parser for Python"
HOMEPAGE="https://andrew-d.github.io/python-multipart"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

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
