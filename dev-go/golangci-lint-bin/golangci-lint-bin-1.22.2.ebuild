# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Linters Runner for Go. 5x faster than gometalinter."
HOMEPAGE="https://github.com/golangci/golangci-lint"

LOCAL_PN="${PN/%-bin}"
MY_P="${LOCAL_PN}-${PV}-linux-amd64"
SRC_URI="https://github.com/golangci/${LOCAL_PN}/releases/download/v${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Go still depends glibc
RDEPEND=">sys-libs/glibc-2.12"

# go binaries come prestripped
RESTRICT="strip"

S="${WORKDIR}/${MY_P}"

src_install() {
	into "/usr"
	dobin golangci-lint
	dodoc README.md
}
