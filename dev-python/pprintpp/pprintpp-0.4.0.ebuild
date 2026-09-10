# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="A drop-in replacement for pprint that's actually pretty"
HOMEPAGE="https://pypi.org/project/pprintpp/"

LICENSE="BSD"
KEYWORDS="~amd64"

SLOT="0"
