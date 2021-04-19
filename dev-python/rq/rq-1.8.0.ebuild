# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="RQ (Redis Queue)"
HOMEPAGE="https://github.com/AcquiredIO/rq"

KEYWORDS="~amd64 ~x86"
LICENSE="rq"

SLOT="0"

IUSE=""

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="${HOMEPAGE}"
	inherit git-r3
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RDEPEND="
	dev-python/redis-py[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
"
