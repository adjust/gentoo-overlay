# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
inherit distutils-r1

DESCRIPTION="Python client library for Zabbix API."
HOMEPAGE="https://pypi.org/project/coreapi/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"

# Depends on httpretty<0.8.7, oldest on portage tree is 0.8.14
RESTRICT=test
