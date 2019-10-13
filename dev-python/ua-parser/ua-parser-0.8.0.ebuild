# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A python implementation of the UA Parser."
HOMEPAGE="https://github.com/ua-parser/uap-python"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

SRC_URI="https://files.pythonhosted.org/packages/b0/02/94ea43fc432fb112fbb62a89855317c41c210fb5239a2ed9b94ecb63024f/${P}.tar.gz"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	${EPYTHON} ua_parser/user_agent_parser_test.py || die "test failed under ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
}
