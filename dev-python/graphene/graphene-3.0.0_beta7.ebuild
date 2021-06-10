# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

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
	${RDEPEND}
"

RESTRICT="test"

S="${WORKDIR}/${MYP}"
