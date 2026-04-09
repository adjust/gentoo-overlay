# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 python3_12 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Plugin utilities for monitoring and controlling processes run by supervisord"
HOMEPAGE="https://pypi.org/project/superlance/"

LICENSE="BSD"
KEYWORDS="~amd64"

SLOT="0"

