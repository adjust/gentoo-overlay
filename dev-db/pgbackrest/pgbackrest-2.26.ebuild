# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple, reliable, scalable backup solution to postgres"
HOMEPAGE="https://pgbackrest.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/release/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"

# Docs depend on XML::Checker::Parser. Skip for now
#IUSE="doc"

DEPEND="
	>=dev-db/postgresql-8.3:=
	sys-libs/zlib
	app-arch/lz4
	dev-libs/openssl
	dev-libs/libxml2
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-release-${PV}/src"

src_install()
{
	# install base configuration
	dodir /etc/"${PN}"
	insinto /etc/"${PN}"
	doins "${FILESDIR}"/pgbackrest.conf
	# user postgres should exist implicitly by dev-db/postgresql
	diropts -m 0775 -g postgres
	keepdir /var/log/"${PN}"
	# async wal archiving requires a spooler directory
	keepdir /var/spool/"{PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	default
}
