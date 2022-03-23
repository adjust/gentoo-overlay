# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

DESCRIPTION="A multi-user server for Jupyter notebooks"
HOMEPAGE="https://github.com/jupyterhub/jupyterhub"
SRC_URI="https://github.com/jupyterhub/jupyterhub/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="ldapauthenticator postgres sudospawner"

RESTRICT=network-sandbox

#dev-libs/kpathsea no mpl plots

distutils_enable_tests pytest

RDEPEND="
	acct-user/jupyterhub
	acct-group/jupyterhub
	>=dev-python/alembic-1.4[${PYTHON_USEDEP}]
	>=dev-python/async_generator-1.9[${PYTHON_USEDEP}]
	>=dev-python/certipy-0.1.2[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.11.0[${PYTHON_USEDEP}]
	>=dev-python/jupyter-telemetry-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-3.0[${PYTHON_USEDEP}]
	dev-python/pamela[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/prometheus_client-0.4.0[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.1[${PYTHON_USEDEP}]
	>=www-servers/tornado-5.1[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.2[${PYTHON_USEDEP}]
	|| ( dev-python/jupyterlab[${PYTHON_USEDEP}] dev-python/jupyter[${PYTHON_USEDEP}] )
	postgres? ( dev-python/psycopg[${PYTHON_USEDEP}] )
	ldapauthenticator? ( dev-python/jupyterhub-ldapauthenticator[${PYTHON_USEDEP}] )
	sudospawner? ( dev-python/sudospawner[${PYTHON_USEDEP}] )
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
	cd ${S} && python -m jupyterhub --generate-config
        distutils-r1_python_install --skip-build
}

python_install_all() {
	distutils-r1_python_install_all
	newinitd "${FILESDIR}"/jupyterhub.initd jupyterhub
	insinto /etc/jupyterhub
	newins ${S}/jupyterhub_config.py config.example.py
}

pkg_preinst() {
	keepdir /var/lib/jupyterhub
	fowners jupyterhub:jupyterhub /var/lib/jupyterhub
}
pkg_postinst() {
        if [ ! -e /etc/jupyterhub/config.py ]; then
                elog
                elog "Please cp /etc/jupyterhub/config.example.py /etc/jupyterhub/config.py"
                elog "And tune it to your needs"
                elog
        else
                elog
                elog "May be it is good idea to compare working config with example one"
                elog "diff /etc/jupyterhub/config.example.py /etc/jupyterhub/config.py"
		elog "and see the changelog at https://jupyterhub.readthedocs.io/en/${PV}/changelog.html"
                elog
        fi
}
