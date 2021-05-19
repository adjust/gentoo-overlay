# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

MYPV="${PV/_beta/b}"
MYP="${PN}-${MYPV}"

DESCRIPTION="GraphQL Framework for Python"
HOMEPAGE="https://github.com/graphql-python/graphene"
SRC_URI="https://github.com/graphql-python/${PN}/archive/v${MYPV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND="
	dev-python/aniso8601[${PYTHON_USEDEP}]
	dev-python/graphql-core[${PYTHON_USEDEP}]
	dev-python/graphql-relay[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/promise[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/snapshottest[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MYP}"

distutils_enable_tests pytest
# ModuleNotFoundError: No module named 'sphinx_graphene_theme'
# There is a archived github, but no releases at the moment
#distutils_enable_sphinx docs
