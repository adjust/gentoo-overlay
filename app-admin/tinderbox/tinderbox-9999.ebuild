# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tinderbox scripts for binhost"
HOMEPAGE="https://github.com/adjust/tinderbox"

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adjust/tinderbox.git"
	KEYWORDS=""
elif [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64"
fi

LICENSE="CC0-1.0"

SLOT="0"

IUSE=""

DEPEND="
	app-admin/trex
"

RDEPEND="
	${DEPEND}
"

src_install() {
	dobin tb*
	insinto /etc
	doins tinderbox.conf
}
