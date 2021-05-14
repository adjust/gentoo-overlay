# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module vcs-snapshot

DESCRIPTION="adjust bagger tools"
HOMEPAGE="https://github.com/adjust/bagger"
SRC_URI="https://github.com/adjust/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Unlicense"
KEYWORDS="~amd64"

SLOT="0"

IUSE="schaufel"

DEPEND="
	dev-perl/Moo
	dev-perl/DBD-Pg
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	dev-perl/DateTimeX-Easy
	dev-perl/Module-Build
	dev-perl/Parallel-ForkManager
	dev-perl/Term-ProgressBar
	dev-perl/Digest-SHA1
"

RDEPEND="
	${DEPEND}
	schaufel? (
		app-admin/schaufel
	)
"

pkg_nofetch() {
	[ -z "${SRC_URI}" ] && return

	# May I have your attention please
	einfo "**************************"
	einfo "Please manually download"
	einfo "$SRC_URI"
	einfo "and put it on binhost"
	einfo "**************************"
}

src_install() {
	mytargets="install"
	perl-module_src_install

	if use schaufel ; then
		newinitd "${FILESDIR}"/schaufel_listener.initd schaufel_listener
		newconfd "${FILESDIR}"/schaufel_listener.confd schaufel_listener
	fi
}
