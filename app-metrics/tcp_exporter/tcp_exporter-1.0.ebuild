# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-build

DESCRIPTION="TCP Exporter built by Adjust GmbH"
HOMEPAGE="https://github.com/adjust/tcp_exporter"
SRC_URI="https://github.com/adjust/tcp_exporter/archive/refs/tags/v1.0.tar.gz -> tcp_exporter-1.0.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go"
RDEPEND="${DEPEND}"

S="${WORKDIR}/tcp_exporter"

src_compile() {
    cd $S
    go build -o tcp_exporter tcp_exporter.go || die "go build failed"
}

src_install() {
    newinitd "${FILESDIR}/tcp_exporter-init" tcp_exporter
    dobin tcp_exporter
	keepdir /var/log/tcp_exporter
}
