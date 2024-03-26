# Copyright 2024 @Leo
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Prometheus exporter for SQL database metrics."
HOMEPAGE="https://github.com/justwatchcom/sql_exporter"
SRC_URI="https://github.com/justwatchcom/sql_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-lang/go
        acct-group/sql_exporter
        acct-user/sql_exporter"
RDEPEND="acct-group/sql_exporter
         acct-user/sql_exporter"
EGO_PN="github.com/justwatchcom/sql_exporter"

src_prepare() {
    default
    cd "${S}" || die
    export GO111MODULE=auto
}

src_compile() {
    export GOPATH="${S}"
    cd "${S}/src/${EGO_PN}" || die
    echo "compiling from $(pwd)" || die
    go build -o "${S}/bin/sql_exporter" || die "Failed to build sql_exporter"
}

src_install() {
    # Create user and group
    enewgroup sql_exporter
    enewuser sql_exporter -1 -1 /var/log/sql_exporter sql_exporter

    dobin "${S}/bin/sql_exporter" || die
    newinitd "${FILESDIR}/sql_exporter.init.d" sql_exporter || die
    exeinto /etc/init.d
    newexe "${FILESDIR}/sql_exporter.init.d" sql_exporter || die
    dosym /etc/init.d/sql_exporter /etc/runlevels/default/sql_exporter || die

    insinto /etc/sql_exporter
    doins "${FILESDIR}/sql_exporter.yml"

    # Create log directory and file
    if ! dodir /var/log/sql_exporter; then
        die "Failed to create log directory"
    fi
    newins /dev/null sql_exporter.log || die "Failed to create log file"
}

src_test() {
    cd "${S}/src/${EGO_PN}" || die
    go test -v ./... || die "Tests failed"
}
