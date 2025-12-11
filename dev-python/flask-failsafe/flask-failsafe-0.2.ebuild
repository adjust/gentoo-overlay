# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..12} )
inherit distutils-r1

DESCRIPTION="A failsafe for the Flask reloader."
HOMEPAGE="
	https://pypi.org/project/flask-failsafe/
	https://github.com/mgood/flask-failsafe/
"
SRC_URI="
	https://github.com/mgood/flask-failsafe/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/flask
"
distutils_enable_tests pytest
