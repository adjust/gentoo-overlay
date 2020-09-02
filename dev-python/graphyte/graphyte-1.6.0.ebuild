# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 python-r1

DESCRIPTION="A small library to send data to graphite"
HOMEPAGE="https://pypi.org/project/graphyte/"
SRC_URI="https://github.com/Jetsetter/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

src_test()
{
	einfo "Testing graphyte."
	python_test()
	{
		$PYTHON test_graphyte.py --verbose
	}
	if ! python_foreach_impl python_test
	then
			eerror "Python tests failed!"
			die
	fi
}
