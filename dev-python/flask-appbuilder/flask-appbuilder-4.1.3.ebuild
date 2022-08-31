# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

MY_PN="Flask-AppBuilder"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple and rapid application development framework, built on top of Flask"
HOMEPAGE="https://pypi.org/project/Flask-AppBuilder/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/Authlib[${PYTHON_USEDEP}]
	dev-python/apispec[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-babel[${PYTHON_USEDEP}]
	dev-python/flask-jwt-extended[${PYTHON_USEDEP}]
	dev-python/flask-login[${PYTHON_USEDEP}]
	dev-python/flask-openid[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
	dev-python/flask-wtf[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/marshmallow[${PYTHON_USEDEP}]
	dev-python/marshmallow-enum[${PYTHON_USEDEP}]
	dev-python/marshmallow-sqlalchemy[${PYTHON_USEDEP}]
	dev-python/prison[${PYTHON_USEDEP}]
	dev-python/python-email-validator[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	<dev-python/wtforms-3[${PYTHON_USEDEP}]
"
