# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=flit

inherit distutils-r1 pypi

DESCRIPTION="asyncio bridge to the standard sqlite3 module"
HOMEPAGE="https://github.com/jreese/aiosqlite"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"
