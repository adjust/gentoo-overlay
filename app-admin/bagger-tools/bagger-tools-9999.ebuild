# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit perl-module git-r3

DESCRIPTION="adjust bagger tools"
HOMEPAGE="https://github.com/adjust/bagger"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/bagger.git"
SLOT="0"
KEYWORDS=""
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

RDEPEND="${DEPEND}
	schaufel? (
		app-admin/schaufel
	)
"

src_install() {
	mytargets="install"
	perl-module_src_install

	if use schaufel;
	then
		newinitd "${FILESDIR}"/schaufel_listener.initd schaufel_listener
		newconfd "${FILESDIR}"/schaufel_listener.confd schaufel_listener
	fi
}
