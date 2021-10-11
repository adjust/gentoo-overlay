# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Run tests on an isolated, temporary PostgreSQL database"
HOMEPAGE="http://ephemeralpg.org/"
SRC_URI="https://bitbucket.org/eradman/${PN}/get/${P}.tar.gz"
SRC_URI="https://github.com/eradman/ephemeralpg/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="ISC"
SLOT="0"
IUSE="test" # TODO: perl & python

RESTRICT="test" # 'works on my notebook' is not valid in general. sigh. ur wat doin?!

DEPEND='test? ( dev-lang/ruby )'

RDEPEND='>=dev-db/postgresql-9.3'

src_compile() {
	emake PREFIX='/usr' MANPREFIX='/usr/share'
}

src_install() {
	emake DESTDIR="${ED}" PREFIX='/usr' MANPREFIX='/usr/share' install
}
