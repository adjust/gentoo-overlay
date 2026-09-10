# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="croniter provides iteration for datetime object with cron like format"
HOMEPAGE="https://pypi.org/project/croniter/"

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
