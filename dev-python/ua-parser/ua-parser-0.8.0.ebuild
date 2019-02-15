# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A python implementation of the UA Parser."
HOMEPAGE="https://github.com/ua-parser/uap-python"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	${EPYTHON} ua_parser/user_agent_parser_test.py || die "test failed under ${EPYTHON}"
}
