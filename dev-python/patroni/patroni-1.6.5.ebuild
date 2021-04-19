# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="PostgreSQL High-Available orchestrator and CLI"
HOMEPAGE="https://pypi.org/project/patroni/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
	)
"
