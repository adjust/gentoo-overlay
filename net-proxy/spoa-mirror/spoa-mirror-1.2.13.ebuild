# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="HAProxy traffic mirroring 3rd party tool"
HOMEPAGE="https://github.com/haproxytech/spoa-mirror"
SRC_URI="https://github.com/haproxytech/spoa-mirror/archive/refs/tags/v1.2.13.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

DEPEND="
	sys-devel/autoconf
	sys-devel/automake
	net-misc/curl
	dev-libs/libev
"

RDEPEND="
	${DEPEND}
"

src_configure() {
	eautoconf
}
