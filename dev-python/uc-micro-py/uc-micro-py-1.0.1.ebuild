# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1 pypi

DESCRIPTION="Micro subset of unicode data files for linkify-it-py projects"
HOMEPAGE="https://pypi.org/project/uc-micro-py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
