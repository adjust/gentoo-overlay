# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

DESCRIPTION="The SudoSpawner enables JupyterHub to spawn single-user servers without being root"
HOMEPAGE="https://github.com/jupyterhub/sudospawner"
SRC_URI="https://github.com/jupyterhub/sudospawner/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jupyterhub[${PYTHON_USEDEP}]
	app-admin/sudo
	acct-user/jupyterhub
        acct-group/jupyterhub
"

src_prepare() {
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
        insinto /etc/sudoers.d
        newins ${FILESDIR}/sudospawner.sudoers sudospawner
	distutils-r1_python_install_all
}

pkg_postinst() {
                elog
                elog "All jupyterhub users should be members of jupyterhub group"
                elog "(see /etc/sudoers.d/jupyterhub)"
                elog
}
