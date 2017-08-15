# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit distutils-r1

HOMEPAGE='https://github.com/googleapis/gax-python'
DESCRIPTION='Google API Extensions'
SLOT='0'
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE='BSD'
SLOT='0'
KEYWORDS='~amd64'
IUSE=''

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
    dev-python/dill[${PYTHON_USEDEP}]
    dev-python/futures[${PYTHON_USEDEP}]
    dev-python/google-auth[${PYTHON_USEDEP}]
    dev-python/grpcio[${PYTHON_USEDEP}]
    dev-python/ply[${PYTHON_USEDEP}]
    dev-python/protobuf-python[${PYTHON_USEDEP}]
    dev-python/requests[${PYTHON_USEDEP}]
    virtual/python-enum34[${PYTHON_USEDEP}]
"
