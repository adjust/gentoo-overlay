# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RESTRICT="test"

EGO_PN="github.com/adjust/${PN}"
inherit golang-build user

SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="PostgreSQL Prometheus Exporter"
HOMEPAGE="https://github.com/adjust/postgresql_exporter"
LICENSE="MIT"
SLOT="0"
IUSE=""

# This package is meant as a replacement so it uses the same user.
RDEPEND="!net-analyzer/prometheus-postgres_exporter"

EXPORTER_USER=prometheus-exporter

pkg_setup() {
	enewgroup "${EXPORTER_USER}"
	enewuser "${EXPORTER_USER}" -1 -1 -1 "${EXPORTER_USER}"
}

src_prepare() {
	default

	# Meet the expectations of the golang-build eclass
	mkdir -p "src/${EGO_PN}" || die
	find . \
		-not -name . -not -wholename '*/src*' -not -wholename '*/vendor*' \
		-exec cp -PR '{}' src/github.com/adjust/postgresql_exporter \; || die
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
	dodoc README.md

	insinto /etc/"${PN}"
	doins configs/*.yaml

	# These collide with net-analyzer/prometheus-postgres_exporter
	keepdir /var/lib/prometheus/"${PN}" /var/log/prometheus
	fowners "${EXPORTER_USER}":"${EXPORTER_USER}" /var/lib/prometheus/"${PN}" /var/log/prometheus

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
