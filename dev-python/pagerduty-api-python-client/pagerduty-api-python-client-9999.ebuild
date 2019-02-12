# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A client in Python for PagerDuty's v2 API."
HOMEPAGE="https://github.com/titov-rabota/pagerduty-api-python-client"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="${HOMEPAGE}"
	inherit git-r3
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/ujson[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

src_prepare() {
	rm -rf test/ || die
	distutils-r1_src_prepare
}
