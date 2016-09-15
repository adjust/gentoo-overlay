# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base user

DESCRIPTION="A tool to create and maintain mirrors of GitHub repositories"
HOMEPAGE="https://github.com/andrewslotin/doppelganger"
EGO_PN="github.com/${PN}/${PN}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE=""

DEPEND=">=dev-lang/go-1.5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src/${EGO_PN}"

DAEMON_USER="git"
LOG_DIR="/var/log/doppelganger"
DATA_DIR="/home/git"

pkg_setup() {
	enewuser ${DAEMON_USER} -1 -1 "${DATA_DIR}"
}

src_unpack() {
	default
	mkdir -p temp/src/${EGO_PN%/*} || die
	mv ${P} temp/src/${EGO_PN} || die
	mv temp ${P} || die
}

src_compile() {
	export GOPATH="${WORKDIR}/${P}"
	emake build
}

src_install() {
	dobin "${PN}"
	dobin "promtool"

	insinto "/etc/prometheus/"
	doins "documentation/examples/prometheus.yml"

	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"

	keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}" "${LOG_DIR}"

	keepdir "${DATA_DIR}"
	fowners "${DAEMON_USER}" "${DATA_DIR}"
}
