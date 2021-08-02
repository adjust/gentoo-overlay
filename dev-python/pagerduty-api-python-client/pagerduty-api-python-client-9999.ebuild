# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1 git-r3 vcs-snapshot

DESCRIPTION="A client in Python for PagerDuty's v2 API."
HOMEPAGE="https://github.com/titov-rabota/pagerduty-api-python-client"

LICENSE="Apache-2.0"
SLOT="0"

IUSE=""

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="${HOMEPAGE}"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
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
