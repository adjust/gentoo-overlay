# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..12} )
inherit distutils-r1 pypi

MY_PN="Flask-OpenID"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="OpenID support for Flask"
HOMEPAGE="https://pypi.org/project/Flask-OpenID/"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/python3-openid[${PYTHON_USEDEP}]
"
