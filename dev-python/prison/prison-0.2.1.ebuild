# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1 pypi

DESCRIPTION="Rison encoder/decoder"
HOMEPAGE="https://pypi.org/project/prison"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
