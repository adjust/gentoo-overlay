# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-opt-2

MY_PN="${PN/-bin/}"

DESCRIPTION="Fault tolerant job scheduler for Mesos"
HOMEPAGE="https://mesos.github.io/chronos/docs"
SRC_URI="https://files.adjust.com/${P}.tar.bz2"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

# The user account "warden" is used across all Mesos/Spark/Chronos services
# to keep the whole user account management consistent across the cluster
# and to avoid running into user permission errors.
RDEPEND="
	acct-group/warden
	acct-user/warden

	net-libs/nodejs
	>=virtual/jdk-1.8
"

DEPEND="
	${RDEPEND}
"

S="${WORKDIR}"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_install() {
	java-pkg_dojar "src/${PN}.jar"

	local x
	for x in /var/{lib,log}/warden; do
		keepdir "${x}"
		fowners warden:warden "${x}"
	done

	newinitd "${FILESDIR}/${MY_PN}.initd" "${MY_PN}"
	newconfd "${FILESDIR}/${MY_PN}.confd" "${MY_PN}"
}
