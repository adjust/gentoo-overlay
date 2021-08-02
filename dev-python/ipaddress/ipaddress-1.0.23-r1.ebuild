# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="IPv4/IPv6 manipulation library, backport of the ipaddress module"
HOMEPAGE="https://github.com/phihag/ipaddress"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i 's:unittest.main():unittest.main(verbosity=2):' \
		test_ipaddress.py || die

	distutils-r1_python_prepare_all
}
