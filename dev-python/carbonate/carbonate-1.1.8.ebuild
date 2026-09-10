# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Utilities for managing graphite clusters"
HOMEPAGE="https://github.com/jssjr/carbonate"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"

SLOT="0"

IUSE=""

RDEPEND="
	dev-python/carbon[${PYTHON_USEDEP}]
	dev-python/whisper[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
