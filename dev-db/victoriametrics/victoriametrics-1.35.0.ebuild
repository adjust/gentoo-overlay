# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base tmpfiles systemd golang-vcs-snapshot

RESTRICT="test" # incomplete tarbllz
EGO_PN="victoriametrics"

DESCRIPTION="VictoriaMetrics TSDB"
HOMEPAGE="https://victoriametrics.com/"
IUSE="cluster"

SRC_URI="!cluster? ( https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v${PV}.tar.gz -> ${P}.tar.gz )
	cluster? ( https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v${PV}-cluster.tar.gz -> ${P}-cluster.tar.gz )"
KEYWORDS="~amd64"

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="dev-lang/go"
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src/${PN}"

src_compile() {
	# need to explicit because makefile does a docker by default
	use cluster &&	emake -j8 vmagent vmalert vmbackup vmrestore vminsert vmselect vmstorage
	use cluster ||  emake -j8 victoria-metrics vmagent vmalert vmbackup vmrestore
}

src_install() {
	# what do you mean make install? you crazy?!
	mkdir -p "${D}/usr/bin"
	cp bin/* "${D}/usr/bin"
}
