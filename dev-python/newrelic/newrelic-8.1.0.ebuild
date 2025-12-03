# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

MY_PN="newrelic"
MY_P="${MY_PN}-${PV}.180"

DESCRIPTION="performance monitoring and advanced analytics for python applications"
HOMEPAGE="https://pypi.org/project/newrelic/"
SRC_URI="https://files.pythonhosted.org/packages/73/59/9a1070788d2462bc38ed7af95f0c0878a597a82307daa60c1015443572b5/${MY_P}.tar.gz"

LICENSE="newrelic"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	<dev-python/setuptools_scm-7[${PYTHON_USEDEP}]
"

SLOT="0"

IUSE=""

S="${WORKDIR}/${MY_P}"
