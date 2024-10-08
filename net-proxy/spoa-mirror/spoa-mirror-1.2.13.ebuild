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

IUSE="debug"

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

	# store our configure opts in this array
	local conf_opts=(
		$(use_enable debug)
	)

	# this generates configure.ac
	./scripts/bootstrap || die "failed to bootstrap"

	# ... finally configure and pass the conf_opts array
	econf "${conf_opts[@]}"
}

