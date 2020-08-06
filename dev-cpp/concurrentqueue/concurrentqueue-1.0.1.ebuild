# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A fast multi-producer, multi-consumer lock-free concurrent queue for C++11"
HOMEPAGE="https://github.com/cameron314/${PN}"
SRC_URI="https://github.com/cameron314/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD-2 Boost-1.0 )"
SLOT="0"
KEYWORDS="amd64"

src_compile() {
	:
}

src_install() {
	doheader *.h
}
