# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6,3_7} )
inherit distutils-r1 git-r3

DESCRIPTION="eBPF based monitoring tool"
HOMEPAGE="https://github.com/adjust/ajtrace"
EGIT_REPO_URI="https://github.com/adjust/ajtrace.git"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-util/bcc
	dev-python/pyyaml
"
