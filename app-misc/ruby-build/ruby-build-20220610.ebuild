# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Command-line utility to install virtually any version of Ruby"
HOMEPAGE="https://github.com/rbenv/ruby-build"
SRC_URI="https://github.com/rbenv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="rbenv"

DEPEND="rbenv? ( app-misc/rbenv )"
RDEPEND="${DEPEND}"

src_install() {
	dobin bin/${PN}

	insinto /usr/share/${PN}
	doins -r share/${PN}/*

	if use rbenv; then
		exeinto /usr/$(get_libdir)/rbenv/libexec
		doexe bin/rbenv-{,un}install
	fi
}
