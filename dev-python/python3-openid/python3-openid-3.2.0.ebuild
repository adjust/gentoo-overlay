# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 pypi

DESCRIPTION="OpenID support for modern servers and consumers"
HOMEPAGE="https://pypi.org/project/python3-openid"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
