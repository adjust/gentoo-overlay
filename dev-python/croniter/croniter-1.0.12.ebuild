# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="croniter provides iteration for datetime object with cron like format"
HOMEPAGE="https://pypi.org/project/croniter/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
