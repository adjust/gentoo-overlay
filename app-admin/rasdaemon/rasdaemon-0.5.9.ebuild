# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils linux-info

DESCRIPTION="Platform Reliability, Availability and Serviceability (RAS) daemon"
HOMEPAGE="https://pagure.io/rasdaemon"
SRC_URI="http://www.infradead.org/~mchehab/rasdaemon/rasdaemon-0.5.9.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sqlite"

DEPEND="sqlite? ( dev-db/sqlite:3 )"
RDEPEND="
	sys-apps/dmidecode
	${DEPEND}
"

src_prepare() {
	default

	# Useful patches from Redhat, picked from rasdaemon-1.4.1 patchset.
	epatch -p1 "${FILESDIR}"/0015-Add-an-example-of-labels-file.patch
	epatch -p1 "${FILESDIR}"/0019-ras-mc-ctl-remove-completely-use-of-modprobe.patch
}

src_configure() {
	econf \
		--includedir="${EPREFIX}"/usr/include/${PN} \
		--localstatedir="${EPREFIX}"/var \
		--enable-aer --enable-extlog --enable-mce \
		$(use_enable 'sqlite' 'sqlite3')
}

src_install() {
	default

	sed -e "s/@RASDAEMON_OPTS@/$(use 'sqlite' && echo -r)/" \
		"${FILESDIR}"/rasdaemon.init.in > "${T}"/${PN}.init || die 'sed init failed'

	newinitd "${T}"/${PN}.init ${PN}
	newinitd "${FILESDIR}"/ras-mc-ctl.init ras-mc-ctl

	# ^^ sample file comes from patch
	insinto /etc/ras/dimm_labels.d
	doins labels/dell

	keepdir /etc/ras/dimm_labels.d
	keepdir /var/lib/${PN}
}

pkg_postinst() {
	kernel_is -lt 3 5 0 && ewarn "$PN requires a Linux kernel >= 3.5.0"
	kernel_is -lt 3 10 0 && ewarn "In order to get full benefit of $PN a Linux kernel >= 3.10 is needed."

	if ! linux_config_exists || ! linux_chkconfig_present EDAC || ! linux_chkconfig_present RAS; then
		ewarn 'Your kernel must include EDAC and RAS support.'
		ewarn '  -> Device Drivers'
		ewarn '     <*> EDAC (Error Detection And Correction) reporting'
		ewarn '     <*> Reliability, Availability and Serviceability (RAS) features'
		echo
		ewarn "You may check the driver status with \`ras-mc-ctl --status'"
	fi
}
