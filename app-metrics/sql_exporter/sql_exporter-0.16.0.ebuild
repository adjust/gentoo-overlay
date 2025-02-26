# Copyright 2024 @Leo
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Prometheus exporter for SQL database metrics."
HOMEPAGE="https://github.com/burningalchemist/sql_exporter"
SRC_URI="
	${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://files.adjust.com/${P}.tar.xz -> ${P}-deps.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="
	dev-lang/go
	acct-group/sql_exporter
	acct-user/sql_exporter"

RDEPEND="${DEPEND}"
BDEPEND=">=dev-util/promu-0.15.0"
SRC_DIR="${WORKDIR}/${P}"

src_unpack() {
	default
}

src_prepare() {
	default
}

src_compile() {
	export GOPATH="${SRC_DIR}"
	cd "${SRC_DIR}"
	promu build -v || die
}

src_test() {
	cd "${SRC_DIR}"
	go test -v ./...
}

src_install() {
	dobin "${PN}"
	newinitd "${FILESDIR}/${PN}.init.d" ${PN}
	dosym /etc/init.d/${PN} /etc/runlevels/default/${PN}
	insinto /etc/${PN}
	doins "${FILESDIR}/${PN}.yml"
	# Create log directory and file
	keepdir /var/log/${PN}
	# Change ownership of the log file to sql_exporter
	fowners ${PN}:${PN} /var/log/${PN}
}
