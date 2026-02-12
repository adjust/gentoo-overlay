# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Simple, reliable, scalable backup solution to postgres"
HOMEPAGE="https://pgbackrest.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/release/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

SLOT="0"

# Docs depend on XML::Checker::Parser. Skip for now
#IUSE="doc"

DEPEND="
	acct-group/postgres
	acct-user/postgres
	>=dev-db/postgresql-9.0:=
	sys-libs/zlib
	app-arch/lz4
	app-arch/bzip2
	dev-libs/openssl
	dev-libs/libxml2
	net-libs/libssh2
	>=app-arch/zstd-1.0
"

RDEPEND="${DEPEND}"

BDEPEND="
  dev-libs/libyaml
  >=dev-build/meson-0.47
"

S="${WORKDIR}/${PN}-release-${PV}"

src_install() {
	meson_src_install
	# install base configuration
	dodir /etc/"${PN}"
	insinto /etc/"${PN}"
	insopts -o postgres -g postgres
	doins "${FILESDIR}"/pgbackrest.conf
	# user postgres should exist implicitly by dev-db/postgresql
	diropts -m 0775 -g postgres
	keepdir /var/log/"${PN}"
	# async wal archiving requires a spooler directory
	keepdir /var/spool/"${PN}"

	insopts -m 0644 -o root -g root
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}
