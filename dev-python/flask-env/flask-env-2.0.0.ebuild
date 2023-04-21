# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..11} )
inherit distutils-r1

DESCRIPTION=""
HOMEPAGE="
	https://pypi.org/project/flask-env/
	https://github.com/brettlangdon/flask-env
"
SRC_URI="
	https://github.com/brettlangdon/${PN}/archive/refs/tags/v${PV}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
