# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="HAProxy traffic mirroring 3rd party tool"
HOMEPAGE="https://github.com/haproxytech/spoa-mirror"

LICENSE="MIT"

SLOT="0"

IUSE=""

EGIT_REPO_URI="https://github.com/haproxytech/spoa-mirror.git"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libev
"

RDEPEND="
	${DEPEND}
"
S="${WORKDIR}"

src_unpack() {
   git clone "${EGIT_REPO_URI}"
}
