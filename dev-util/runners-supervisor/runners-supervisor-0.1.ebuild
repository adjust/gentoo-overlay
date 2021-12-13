# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A supervisor that manages ephemeral github runners"
HOMEPAGE="https://www.adjust.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	acct-group/github_runner
	acct-user/github_runner
	app-misc/jq
"

S="${WORKDIR}"
DEST="opt/${PN}"

src_unpack() {
	cp "${FILESDIR}/${PN}.sh" "${S}/" || die
}

src_install() {
	dodir "${DEST}"
	insinto "${DEST}"
	doins -r ${S}/*
	fowners -R github_runner:github_runner /${DEST}
	fperms +x /${DEST}/${PN}.sh
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
