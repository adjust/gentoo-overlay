# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/ikitiki/${PN}"
inherit golang-build

SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="PostgreSQL Prometheus Exporter"
HOMEPAGE="https://github.com/ikitiki/postgresql_exporter"
LICENSE="MIT"
SLOT="0"
IUSE=""

src_prepare() {
	default

	# Meet the expectations of the golang-build eclass
	mkdir -p "src/${EGO_PN}" || die
	find . \
		-not -name . -not -wholename '*/src*' -not -wholename '*/vendor*' \
		-exec cp -PR '{}' src/github.com/ikitiki/postgresql_exporter \; || die
	cp -PR vendor/* src/ || die

	# Makefile needs fix for LDFLAGS handling to meet the expectations of emake.
	sed -i \
		-e 's/LDFLAGS ?=/LDFLAGS =/' \
		Makefile || die
}

src_compile() {
	# TODO: default golang-build src_compile does not work.
	# We pass VERSION explicitly, or else Makefile relies on git-describe
	GOPATH="${S}" make VERSION=${PV} all || die
}

src_install() {
	newbin pg-prometheus-exporter "${PN}"
	dodoc -r configs README.md
}
