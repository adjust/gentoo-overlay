# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=poetry
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Relay library for graphql-core-next"
HOMEPAGE="https://github.com/graphql-python/graphql-relay-py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	dev-python/graphql-core[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
