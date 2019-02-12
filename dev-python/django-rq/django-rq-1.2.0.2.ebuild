# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Django integration with RQ, a Redis based Python queuing library"
HOMEPAGE="https://github.com/AcquiredIO/django-rq"
LICENSE="MIT"
SLOT="0"
IUSE="sentry"
KEYWORDS="~amd64 ~x86"

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
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/rq[${PYTHON_USEDEP}]
	sentry? ( dev-python/raven[${PYTHON_USEDEP}] )
"
