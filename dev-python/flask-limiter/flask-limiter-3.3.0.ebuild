# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..11} )
inherit distutils-r1
MY_P="Flask-Limiter-${PV}"
DESCRIPTION=""
HOMEPAGE="
	https://pypi.org/project/flask-limiter/
	https://github.com/alisaifee/flask-limiter
"
SRC_URI="
	https://github.com/alisaifee/flask-limiter/releases/download/${PV}/${MY_P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

RDEPEND="
	>=dev-python/flask-2.0.0[${PYTHON_USEDEP}]
	>dev-python/ordered-set-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/rich-12.0.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4[${PYTHON_USEDEP}]
"
python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	einstalldocs
}
distutils_enable_tests pytest
