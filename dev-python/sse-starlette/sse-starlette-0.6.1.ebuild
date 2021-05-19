# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Server Sent Events for Starlette"
HOMEPAGE="https://pypi.org/project/sse-starlette/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"

SLOT="0"

# BDEPEND="test? (
#	dev-python/starlette[${PYTHON_USEDEP}]
# )"
