# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="${PN//-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="swagger-ui files in a pip package"
HOMEPAGE="https://pypi.org/project/swagger-ui-bundle"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
"
