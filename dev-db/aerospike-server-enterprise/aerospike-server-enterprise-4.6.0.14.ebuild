# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Flash-optimized, in-memory, nosql database"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/artifacts/${PN}/${PV}/${P}-debian8.tgz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	acct-group/aerospike
	acct-user/aerospike
	!dev-db/aerospike-server-community
	dev-lang/python:2.7
	net-nds/openldap
	sys-process/numactl
	|| (
		dev-libs/openssl-compat:1.0.0
		<dev-libs/openssl-1.1:*
	)
	>=virtual/jre-1.8
	sys-libs/readline-compat"

DEPEND="
	>=virtual/jdk-1.8
	app-arch/xz-utils"

S="${WORKDIR}/${P}-debian8"

RESTRICT="fetch"

# change me at every version bump
TOOLS_PV="3.21.1"

src_prepare() {
	local server_deb="${P}.debian8.x86_64.deb"
	local tools_deb="aerospike-tools-${TOOLS_PV}.debian8.x86_64.deb"

	ar x "${server_deb}" || die
	tar xf data.tar.xz && rm data.tar.xz || die

	ar x "${tools_deb}" || die
	tar xf data.tar.xz && rm data.tar.xz || die

	rm *.deb asinstall control.tar.gz debian-binary LICENSE SHA256SUMS
	rm usr/bin/{asfixownership,asmigrate2to3}
}

src_install() {
	insinto /opt/
	doins -r opt/aerospike

	fperms +x -R /opt/aerospike/bin/
	fperms +x -R /opt/aerospike/lib/python/

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

	for i in  opt/aerospike/bin/*; do
		echo $i
		sed -i -e "1s: python$: python2:" $i
		sed -i -e "1s:/usr/bin/python:/usr/bin/python2:" $i
		head -n1 $i
	done
}
