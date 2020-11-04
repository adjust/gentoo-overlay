# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="NS1 Python SDK"
HOMEPAGE="https://github.com/ns1/ns1-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/pytest-runner dev-python/wheel"
RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
