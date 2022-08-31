# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

DESCRIPTION="A pluggable API specification generator."
HOMEPAGE="https://github.com/marshmallow-code/apispec/"
SRC_URI="https://github.com/marshmallow-code/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

RDEPEND="
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
"
