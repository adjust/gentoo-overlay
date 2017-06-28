# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3

DESCRIPTION="Tinderbox scripts for binhost"
HOMEPAGE="https://github.com/adjust/tinderbox"
EGIT_REPO_URI="https://github.com/adjust/tinderbox.git"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-admin/rex"
RDEPEND="${DEPEND}"

src_install() {
	dobin tb*
	insinto /etc
	doins tinderbox.conf
}
