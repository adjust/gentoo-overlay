# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="MetaBase driver for the ClickHouse database"
HOMEPAGE="https://github.com/enqueue/metabase-clickhouse-driver"

MY_PN="clickhouse.metabase-driver"
SRC_URI="${HOMEPAGE}/releases/download/${PV/_/-}/${MY_PN}.jar -> ${P}.jar"

LICENSE="eclipse-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-db/metabase-bin-0.34.0
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
INSTALL_DIR="/opt/metabase/lib/plugins"

src_unpack() {
	mkdir -p "${S}" || die
	cp "${DISTDIR}/${P}.jar" "${S}/${MY_PN}.jar" || die
}

src_install() {
	dodir "${INSTALL_DIR}/"
	cp -pRP * "${ED}/${INSTALL_DIR}" || die
}
