# Copyright 2024 @Leo
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Prometheus exporter for SQL database metrics."
HOMEPAGE="https://github.com/burningalchemist/sql_exporter"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="
	dev-lang/go
	acct-group/sql_exporter
	acct-user/sql_exporter"

RDEPEND="
	${DEPEND}"

EGO_PN="github.com/burningalchemist/sql_exporter"

src_prepare() {
	default
	cd "${S}"
	export GO111MODULE=auto
}

src_compile() {
	export GOPATH="${S}"
	cd "${S}/src/${EGO_PN}"
	echo "compiling from $(pwd)"
	go build -o "${S}/bin/sql_exporter"
}

src_test() {
	cd "${S}/src/${EGO_PN}"
	go test -v ./... 
}

src_install() {
    dobin "${S}/bin/sql_exporter"
    newinitd "${FILESDIR}/sql_exporter.init.d" sql_exporter
    dosym /etc/init.d/sql_exporter /etc/runlevels/default/sql_exporter

    insinto /etc/sql_exporter
    doins "${FILESDIR}/sql_exporter.yml"

    # Create log directory and file
    dodir /var/log/sql_exporter
    touch "${ED}"/var/log/sql_exporter/sql_exporter.log

    # Change ownership of the log file to sql_exporter
    chown sql_exporter:sql_exporter "${ED}"/var/log/sql_exporter/sql_exporter.log
}
