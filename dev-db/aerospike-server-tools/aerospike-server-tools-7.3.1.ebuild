# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Flash-optimized, in-memory, nosql database"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/artifacts/aerospike-server-enterprise/6.1.0.4/aerospike-server-enterprise-6.1.0.4-debian9.tgz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	acct-group/aerospike
	acct-user/aerospike
	!dev-db/aerospike-server-community
"

DEPEND="app-arch/xz-utils"

S="${WORKDIR}/aerospike-server-enterprise-6.1.0.4-debian9"

src_prepare() {
	eapply_user

	local tools_deb="aerospike-tools-${PV}.debian9.x86_64.deb"

	ar x "${tools_deb}" || die
	tar xf data.tar.xz && rm data.tar.xz || die

	rm *.deb asinstall control.tar.gz debian-binary LICENSE SHA256SUMS || die
}

src_install() {
	insinto /opt/
	doins -r opt/aerospike

	fperms +x -R /opt/aerospike/bin/
	fperms +x -R /opt/aerospike/lib/python/

	insinto /usr/bin
	doins usr/bin/*

	fowners -R aerospike:aerospike /opt/aerospike/

	# fix dependencies for aql
	if test -f "/lib64/libreadline.so.7"; then
		# required version exists, create the symlink `aql` looks for
		dosym /lib64/`readlink /lib64/libreadline.so.7` /usr/lib64/libreadline.so.7
	elif test -f "/lib64/libreadline.so.6"; then
		# fallback to version 6 with the required name that `aql` looks for
		dosym /lib64/`readlink /lib64/libreadline.so.6` /usr/lib64/libreadline.so.7
	else
		# create a link to version 8 with the required name
		dosym /lib64/`readlink /lib64/libreadline.so.8` /usr/lib64/libreadline.so.7
	fi
	if test -f "/lib64/libhistory.so.7"; then
		# required version exists, create the symlink `aql` looks for
		dosym /lib64/`readlink /lib64/libhistory.so.7` /usr/lib64/libhistory.so.7
	elif test -f "/lib64/libhistory.so.6"; then
		# fallback to version 6 with the required name that aql looks for
		dosym /lib64/`readlink /lib64/libhistory.so.6` /usr/lib64/libhistory.so.7
	else
		# create a link to version 8 with the required name
		dosym /lib64/`readlink /lib64/libhistory.so.8` /usr/lib64/libhistory.so.7
	fi
}
