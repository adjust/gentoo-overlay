# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="SQLAlchemy integration with the marshmallow (de)serialization library."
HOMEPAGE="https://marshmallow-sqlalchemy.readthedocs.io/"
SRC_URI="https://github.com/marshmallow-code/${PN}/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-python/marshmallow-2.15.2[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.2.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.2.0[sqlite,${PYTHON_USEDEP}]
		>=dev-python/marshmallow-2.15.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
