# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An implementation of Etsy's statsd in go"
HOMEPAGE="https://github.com/atlassian/gostatsd"

MY_PN="${PN/%-bin}"
SRC_URI="https://files.adjust.com/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Go still depends glibc
RDEPEND="
	>sys-libs/glibc-2.12
	acct-user/gostatsd
	acct-group/gostatsd
"

# go binaries come prestripped
RESTRICT="strip"

S="${WORKDIR}/${MY_PN}"

src_install() {
	into "/usr"
	dobin gostatsd
	dodoc *.md
	newinitd "${FILESDIR}"/"${MY_PN}"-"${PV}".initd gostatsd
	newconfd "${FILESDIR}"/"${MY_PN}"-"${PV}".confd gostatsd
}
