# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vcs-snapshot

RESTRICT="test" # 'works on my notebook' is not valid in general. sigh. ur wat doin?!
DESCRIPTION="Run tests on an isolated, temporary PostgreSQL database"
HOMEPAGE="http://ephemeralpg.org/"
SRC_URI="https://bitbucket.org/eradman/${PN}/get/${P}.tar.gz"
# FIXME: Old uri is broken although ^^ main page links to it.
# Report upstream!
# SRC_URI="${HOMEPAGE}/code/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="ISC"
SLOT="0"
IUSE="test" # TODO: perl & python

DEPEND='test? ( dev-lang/ruby )'
RDEPEND='>=dev-db/postgresql-9.3'

src_compile() {
	emake DESTDIR="${D}" PREFIX='/usr' MANPREFIX='/usr/share'
}

src_install() {
	emake DESTDIR="${D}" PREFIX='/usr' MANPREFIX='/usr/share' install
}
