# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Multi-user server for Jupyter notebooks"
HOMEPAGE="https://github.com/jupyterhub/jupyterhub"
SRC_URI="https://github.com/jupyterhub/jupyterhub/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64"

SLOT="0"

IUSE="ldapauthenticator"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RDEPEND="
	net-libs/nodejs
	dev-python/alembic[${PYTHON_USEDEP}]
	>=dev-python/async_generator-1.8[${PYTHON_USEDEP}]
	>=dev-python/certipy-0.1.2[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jupyter-telemetry[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	dev-python/pamela[${PYTHON_USEDEP}]
	>=dev-python/prometheus_client-0.0.21[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.1[${PYTHON_USEDEP}]
	>=www-servers/tornado-5.0[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.2[${PYTHON_USEDEP}]
	ldapauthenticator? ( dev-python/jupyterhub-ldapauthenticator[${PYTHON_USEDEP}] )
"

src_prepare() {
	einfo
	einfo 'Note, allowing network access from the sandbox via RESTRICT=network-sandbox'
	einfo '(needed for building jupyterhub assets via npm)'
	einfo
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
	distutils-r1_python_install_all
}
