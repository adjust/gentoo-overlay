# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RESTRICT="test"

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Extension of Python package pycountry providing conversion functions."
HOMEPAGE="https://pypi.org/project/pycountry-convert/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

# why the * would you depend on a test runner at build time
# how do you end up depending on wheel at runtime
#aaaaAAAAaaaaaaaAAAAAA
DEPEND="dev-python/pycountry[${PYTHON_USEDEP}]
	dev-python/pprintpp[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/repoze-lru[${PYTHON_USEDEP}]
	dev-python/pytest-cov[${PYTHON_USEDEP}]
	dev-python/pytest-mock[${PYTHON_USEDEP}]
"

RDEPEND="
	${DEPEND}
"

src_prepare() {
	sed -i -e 's/pytest-runner//' setup.py || die
	default
}
