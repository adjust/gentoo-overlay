# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

SERVER=8.0.0.5

DESCRIPTION="Flash-optimized, in-memory, nosql database"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/artifacts/aerospike-server-enterprise/${SERVER}/aerospike-server-enterprise_${SERVER}_tools-${PV}_debian12_x86_64.tgz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	acct-group/aerospike
	acct-user/aerospike
  dev-db/aerospike-server-enterprise
"

DEPEND="
	app-arch/xz-utils"

S="${WORKDIR}/aerospike-server-enterprise_${SERVER}_tools-${PV}_debian12_x86_64"

src_prepare() {
	eapply_user

	local tools_deb="${PN/-server/}_${PV}-debian12_amd64.deb"
  unpack_deb ${tools_deb}
}

src_install() {
	insinto /opt/
	doins -r opt/aerospike

	fperms +x -R /opt/aerospike/bin/

	insinto /usr/bin
	doins usr/bin/*

	fowners -R aerospike:aerospike /opt/aerospike/
}
