# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..12} )
inherit distutils-r1

DESCRIPTION="vault encryption key gateway for ZFS"
HOMEPAGE="
	https://github.com/adjust/zkg
"
SRC_URI="
	https://github.com/adjust/${PN}/releases/download/v${PV}/${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # Tests are not working here

RDEPEND="
	dev-python/waitress[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/hvac[${PYTHON_USEDEP}]
  dev-python/flask-env[${PYTHON_USEDEP}]
  dev-python/flask-limiter[${PYTHON_USEDEP}]
  dev-python/flask-failsafe[${PYTHON_USEDEP}]
"

python_install_all() {
  distutils-r1_python_install_all
  keepdir "/var/log/${PN}"
  newinitd "${FILESDIR}/${PN}.initd" ${PN}
  newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
