# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7} )
inherit distutils-r1

DESCRIPTION="PostgreSQL High-Available orchestrator and CLI"
HOMEPAGE="https://pypi.org/project/patroni/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	test? (
	dev-python/flake8[${PYTHON_USEDEP}]
	)
"
