# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit distutils-r1

HOMEPAGE='https://github.com/googleapis/googleapis'
DESCRIPTION='GAPIC library for the Cloud Pub/Sub API'
SLOT='0'
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE='Apache-2.0'
SLOT='0'
KEYWORDS='~amd64'
IUSE=''

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
    dev-python/google-gax[${PYTHON_USEDEP}]
"
