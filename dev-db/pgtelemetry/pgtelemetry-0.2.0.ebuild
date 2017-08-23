# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

DESCRIPTION="Useful views and queries for PostgreSQL monitoring"
HOMEPAGE="http://big-elephants.com/pg-telemetry"
SRC_URI="https://api.pgxn.org/dist/pgtelemetry/${PV}/pgtelemetry-${PV}.zip"
LICENSE="POSTGRESQL GPL-2"

RDEPEND=">=dev-db/postgresql-9.6.4"
DEPEND="${DEPEND}"
KEYWORDS="~amd64"

SLOT=0

src_compile() {
	emake USE_PGXS=1
}

src_install() {
	emake DESTDIR="${D}" USE_PGXS=1 install
}
