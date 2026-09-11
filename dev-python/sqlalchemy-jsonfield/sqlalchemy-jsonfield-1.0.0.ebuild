# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=SQLAlchemy-JSONField
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1 pypi

DESCRIPTION="SQLALchemy JSONField implementation for storing dicts at SQL"
HOMEPAGE="https://pypi.org/project/SQLAlchemy-JSONField"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
"
