# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Utilities for managing graphite clusters"
HOMEPAGE="https://github.com/jssjr/carbonate"
SRC_URI="mirror://pypi/c/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
IUSE=""

RDEPEND="
	dev-python/carbon[${PYTHON_USEDEP}]
	dev-python/whisper[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
