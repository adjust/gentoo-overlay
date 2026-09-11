# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 pypi

DESCRIPTION="swagger-ui files in a pip package"
HOMEPAGE="https://pypi.org/project/swagger-ui-bundle"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
"
