# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="dev-python/mkdocs-material"
DOCS_AUTODOC=1

inherit distutils-r1 docs optfeature

DESCRIPTION="The little ASGI framework that shines"
HOMEPAGE="https://www.starlette.io/"
SRC_URI="https://github.com/encode/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"

RDEPEND="
	dev-python/aiofiles[${PYTHON_USEDEP}]
	dev-python/aiosqlite[${PYTHON_USEDEP}]
	dev-python/graphene[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/python-multipart[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/sse-starlette[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
"

python_prepare_all() {
	# do not install LICENSE to /usr/
	sed -i -e '/data_files/d' setup.py || die
	# do not depend on pytest-cov
	sed -i -e '/--cov/d' setup.cfg || die

	distutils-r1_python_prepare_all
}
