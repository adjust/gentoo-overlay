# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Elixir programming language"
HOMEPAGE="https://elixir-lang.org"
SRC_URI="https://github.com/elixir-lang/elixir/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 ErlPL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=

DEPEND="=dev-lang/erlang-19.1:0=[ssl]"

RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" PREFIX="${EPREFIX}/usr" install
	dodoc README.md CHANGELOG.md CODE_OF_CONDUCT.md
}
