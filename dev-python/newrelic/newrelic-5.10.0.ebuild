# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

MY_PN="newrelic"
MY_P="${MY_PN}-${PV}.138"

DESCRIPTION="performance monitoring and advanced analytics for python applications"
HOMEPAGE="https://pypi.org/project/newrelic/"
SRC_URI="https://files.pythonhosted.org/packages/d5/35/c017210a282c773f8b8dd8d23df1bd39c1bd271ed1f1b8bc29b60b64dbd8/${MY_P}.tar.gz"

LICENSE="newrelic"
KEYWORDS="amd64 x86"

SLOT="0"

IUSE=""

S="${WORKDIR}/${MY_P}"
