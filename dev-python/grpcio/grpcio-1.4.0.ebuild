# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

HOMEPAGE='http://www.grpc.io'
DESCRIPTION='HTTP/2-based RPC framework'
SLOT='0'
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE='BSD-3'
SLOT='0'
KEYWORDS='~amd64'
IUSE=''

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
    dev-python/futures[${PYTHON_USEDEP}]
    dev-python/protobuf-python[${PYTHON_USEDEP}]
    dev-python/six[${PYTHON_USEDEP}]
    virtual/python-enum34[${PYTHON_USEDEP}]
"
