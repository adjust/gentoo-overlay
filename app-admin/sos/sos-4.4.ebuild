# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A tool that collects configuration details from a Linux system"
HOMEPAGE="https://github.com/sosreport/sos"
SRC_URI="https://github.com/sosreport/sos/archive/refs/tags/4.4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
        dev-python/pycodestyle
        dev-python/coverage
        dev-python/sphinx
        dev-python/pyyaml
        dev-python/setuptools
"
