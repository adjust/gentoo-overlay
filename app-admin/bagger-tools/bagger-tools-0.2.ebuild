# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit perl-module

DESCRIPTION="adjust bagger tools"
HOMEPAGE="https://github.com/adjust/bagger"
SLOT="0"
IUSE="schaufel bagger"
LICENSE="Unlicense"

if [[ ${PV} == 9999 ]]
then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/adjust/bagger.git"
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/adjust/${PN}/archive/v${PVR}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

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

RDEPEND="${DEPEND}
	schaufel? (
		app-admin/schaufel
	)
	bagger? (
		>=dev-db/bagger-data-${PVR}
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

	if use schaufel;
	then
		newinitd "${FILESDIR}"/schaufel_listener.${PVR}.initd schaufel_listener
		newconfd "${FILESDIR}"/schaufel_listener.${PVR}.confd schaufel_listener
	fi
}
