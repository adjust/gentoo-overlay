# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=poetry
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="GraphQL for Python"
HOMEPAGE="https://github.com/graphql-python/graphql-core"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
