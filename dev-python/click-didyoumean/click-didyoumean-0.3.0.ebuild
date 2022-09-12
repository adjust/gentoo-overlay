# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Enables git-like *did-you-mean* feature in click"
HOMEPAGE="https://pypi.org/project/click-didyoumean"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-python/poetry-core[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"
