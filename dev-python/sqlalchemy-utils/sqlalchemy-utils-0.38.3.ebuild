# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

MY_PN="SQLAlchemy-Utils"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Various utility functions for SQLAlchemy"
HOMEPAGE="https://pypi.org/project/SQLAlchemy-JSONField"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
"
