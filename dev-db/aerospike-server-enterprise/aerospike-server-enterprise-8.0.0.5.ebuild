# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

TOOLS=11.2.0

DESCRIPTION="Flash-optimized, in-memory, nosql database"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/artifacts/${PN}/${PV}/${PN}_${PV}_tools-${TOOLS}_debian12_x86_64.tgz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	acct-group/aerospike
	acct-user/aerospike
	>net-nds/openldap-2.6
	sys-process/numactl
  net-misc/curl
	|| (
		dev-libs/openssl-compat:1.0.0
		<dev-libs/openssl-1.1:*
	)
"

DEPEND="
	app-arch/xz-utils"

S="${WORKDIR}/${PN}_${PV}_tools-${TOOLS}_debian12_x86_64"

src_prepare() {
	eapply_user

	local server_deb="${PN}_${PV}-1debian12_amd64.deb"
  unpack_deb ${server_deb}
}

src_install() {
	insinto /opt/
	doins -r opt/aerospike

	fperms +x -R /opt/aerospike/bin/

	for dir in '/etc' '/var/log'; do
		keepdir "${dir}/aerospike"
	done

	insinto /etc/aerospike
	for conf in 'aerospike.conf' 'aerospike_mesh.conf' 'aerospike_ssd.conf'; do
		doins "${FILESDIR}/${conf}"
	done

	insinto /usr/bin
	doins usr/bin/*
	fperms +x -R /usr/bin/asd

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/aerospike.logrotate aerospike

	newinitd "${FILESDIR}"/aerospike.init2 aerospike

	fowners -R aerospike:aerospike /opt/aerospike/
	fowners aerospike:aerospike /usr/bin/asd
	fowners -R aerospike:aerospike /var/log/aerospike
}
