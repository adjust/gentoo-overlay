# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Django_replicated is a Django database router"
HOMEPAGE="https://github.com/AcquiredIO/django_replicated"
LICENSE="django_replicated"
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
