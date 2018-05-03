# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3 python-utils-r1

DESCRIPTION="Parse log files, generate metrics for Graphite and Ganglia"
HOMEPAGE="https://github.com/etsy/logster"
EGIT_REPO_URI="https://github.com/etsy/logster"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

DEPEND="app-admin/logcheck"
RDEPEND="${DEPEND}"
