# Copyright 2024 @Belha
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Prometheus exporter for PGBackrest metrics."
HOMEPAGE="https://github.com/woblerr/pgbackrest_exporter"
SRC_URI="
  ${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
  https://files.adjust.com/${P}.tar.xz -> ${P}-deps.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="
  >=dev-lang/go-1.24.0
  acct-group/postgres
  acct-user/postgres
"

RDEPEND="${DEPEND}"
BDEPEND="
  dev-build/make
"
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
  emake build
}

src_test() {
  cd "${SRC_DIR}"
  emake test
}

src_install() {
  dobin "${PN}"
  newinitd "${FILESDIR}/${PN}.initd" ${PN}
  newconfd "${FILESDIR}/${PN}.confd" ${PN}
  # Create log directory and file
  keepdir /var/log/${PN}
  # Change ownership of the log file to sql_exporter
  fowners postgres:postgres /var/log/${PN}
}
