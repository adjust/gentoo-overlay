# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN}"

DESCRIPTION="Runs a job from a GitHub Actions workflow"
HOMEPAGE="https://github.com/actions/runner"
SRC_URI="https://github.com/actions/runner/releases/download/v${PV}/${PN}-linux-x64-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
RESTRICT="strip"

SLOT="0"

DEST="opt/${PN}"

S="${WORKDIR}"

RDEPEND="
		acct-user/github_runner
		acct-group/github_runner
"
DEPEND="
		${RDEPEND}
"

src_install() {
	dodir "${DEST}" || die "Install failed, cannot create ${DEST}"
	insinto "${DEST}" || die
	doins -r  ${S}/* || die "Install failed, cannot accesss ${DEST}"
	fowners -R github_runner:github_runner /${DEST}
	for f in config env run; do
		fperms +x /${DEST}/${f}.sh
	done
	fperms -R +x /${DEST}/bin/
	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
}
