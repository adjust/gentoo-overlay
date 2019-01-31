# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python library that provides an easy way to identify/detect devices".
HOMEPAGE="https://github.com/selwin/python-user-agents"
LICENSE="MIT"
SLOT="0"
IUSE=""

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/selwin/python-user-agents"
	inherit git-r3
else
	SRC_URI="https://github.com/selwin/python-user-agents/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
fi

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/ua-parser[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	${EPYTHON} -m unittest discover || die "test failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
}

