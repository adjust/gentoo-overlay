# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="NS1 Python SDK"
HOMEPAGE="https://github.com/ns1/ns1-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

DEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"
