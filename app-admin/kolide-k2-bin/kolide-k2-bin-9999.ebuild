# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd

DESCRIPTION="Kolide-k2 supervision/telemetry system"
HOMEPAGE="https://kolide.com"

LICENSE="kolide"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
SRC_URI="kolide-launcher.tar"

# Go still depends glibc
RDEPEND=">sys-libs/glibc-2.12"

# Because no
RESTRICT="fetch strip bindist"

S="${WORKDIR}"

src_prepare() {
	# Belongs into /opt
	sed -i -e "s:/var/kolide-k2:/opt/kolide-k2:" "etc/kolide-k2/launcher.flags"
	sed -i -e "s:/usr/local/kolide-k2:/opt/kolide-k2:" \
		"etc/kolide-k2/launcher.flags" \
		"lib/systemd/system/launcher.kolide-k2.service"

	eapply_user
}

src_install() {
	into /opt/kolide-k2
	insinto /opt/kolide-k2
	dobin usr/local/kolide-k2/bin/*
	doins -r var/kolide-k2

	insinto /etc/
	doins -r etc/kolide-k2

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/kolide-k2.logrotate kolide-k2

	newinitd "${FILESDIR}"/kolide-k2.initd kolide-k2
	systemd_dounit "lib/systemd/system/launcher.kolide-k2.service"
}

pkg_postinst() {
	ewarn "******************************************"
	elog  "Please add kolide to your default runlevel"
	elog  "rc-update add kolide-k2 default"
	ewarn "******************************************"
}

pkg_nofetch() {
	ewarn "******************************************"
	elog  "Please contact your local admin to acquire"
	elog  "a copy of this package"
	ewarn "******************************************"
}
