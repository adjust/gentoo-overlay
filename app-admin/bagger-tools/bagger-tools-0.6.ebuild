# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module vcs-snapshot

DESCRIPTION="adjust bagger tools"
HOMEPAGE="https://github.com/adjust/bagger"
SRC_URI="https://github.com/adjust/${PN}/archive/v${PVR}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Unlicense"
KEYWORDS="~amd64"

SLOT="0"

IUSE="schaufel bagger master"

DEPEND="
	dev-perl/Moo
	dev-perl/DBD-Pg
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	dev-perl/DateTimeX-Easy
	dev-perl/JSON
	dev-perl/Module-Build
	dev-perl/Parallel-ForkManager
	dev-perl/Term-ProgressBar
	dev-perl/Digest-SHA1
	dev-perl/IPC-Shareable
	dev-perl/Config-INI
	dev-perl/Hash-Merge
	virtual/perl-Sys-Syslog
"

BDEPEND="
	dev-perl/Module-Build
"

RDEPEND="
	${DEPEND}
	schaufel? (
		app-admin/schaufel
	)
	bagger? (
		>=dev-db/bagger-data-${PV}
	)
	master? (
		>=dev-db/bagger-master-${PV}
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
		newinitd "${FILESDIR}"/schaufel_listener-${PVR}.initd schaufel_listener
		newconfd "${FILESDIR}"/schaufel_listener-${PVR}.confd schaufel_listener
	fi
	insinto /etc
	doins "${FILESDIR}"/bagger.ini
}

# keep system retention hack
pkg_preinst() {
	RETENTION="$(perl -e 'use Bagger::Constants; print Bagger::Constants::max_offset()' 2> /dev/null)"
	RETENTION="${RETENTION//[^[:digit]]/}"
	CONSTANTS="$(find ${D}/etc/bagger.ini 2>/dev/null)"

	[ -z "${RETENTION}" ] || [ -z "${CONSTANTS}" ] && return
	einfo "***************************************"
	einfo "Applying Cluster config to Bagger.ini"
	einfo "***************************************"
	einfo "Retention: $RETENTION"
	sed -r "s/(max_offset\s+=) 24\*18/\1 ${RETENTION}/" -i "${CONSTANTS}" || die
}
