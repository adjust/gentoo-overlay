# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python library that reads key value pairs into environment".
HOMEPAGE="https://github.com/theskumar/python-dotenv"

LICENSE="python-dotenv"

SLOT="0"

IUSE="cli"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/theskumar/python-dotenv"
	inherit git-r3
else
	SRC_URI="https://github.com/theskumar/python-dotenv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
fi

RDEPEND="
	cli? ( dev-python/click[$PYTHON_USEDEP] )
"
