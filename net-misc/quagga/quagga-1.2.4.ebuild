# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic pam readme.gentoo-r1 systemd tmpfiles

DESCRIPTION="A free routing daemon"
HOMEPAGE="https://www.nongnu.org/quagga https://github.com/Quagga"
SRC_URI="
	https://github.com/Quagga/${PN}/releases/download/${P}/${P}.tar.gz
	https://files.adjust.com/${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

IUSE="caps fpm doc elibc_glibc ipv6 multipath nhrpd ospfapi pam protobuf +readline snmp tcp-zebra test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	acct-group/quagga
	acct-user/quagga
	virtual/libcrypt:=
	caps? ( sys-libs/libcap )
	nhrpd? ( net-dns/c-ares:0= )
	protobuf? ( dev-libs/protobuf-c:0= )
	readline? (
		sys-libs/readline:0=
		pam? ( sys-libs/pam )
	)
	snmp? ( net-analyzer/net-snmp:= )
	!elibc_glibc? ( dev-libs/libpcre )"
DEPEND="${COMMON_DEPEND}
	sys-apps/gawk
	dev-build/libtool:2
	test? ( dev-util/dejagnu )"
RDEPEND="${COMMON_DEPEND}
	sys-apps/iproute2"

PATCHES=(
	"${FILESDIR}/${PN}-0.99.22.4-ipctl-forwarding.patch"
)

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Sample configuration files can be found in /usr/share/doc/${PF}/samples
You have to create config files in /etc/quagga before
starting one of the daemons.

You can pass additional options to the daemon by setting the EXTRA_OPTS
variable in their respective file in /etc/conf.d"

src_configure() {
	# -fcommon is added as a workaround for bug #707422
	append-flags -fno-strict-aliasing -fcommon

	# do not build PDF docs
	export ac_cv_prog_PDFLATEX=no
	export ac_cv_prog_LATEXMK=no

	econf \
		--enable-exampledir=/usr/share/doc/${PF}/samples \
		--enable-irdp \
		--enable-isisd \
		--enable-isis-topology \
		--enable-pimd \
		--enable-user=quagga \
		--enable-group=quagga \
		--enable-vty-group=quagga \
		--with-cflags="${CFLAGS}" \
		--with-pkg-extra-version="-gentoo" \
		--sysconfdir=/etc/quagga \
		--localstatedir=/run/quagga \
		--disable-static \
		$(use_enable caps capabilities) \
		$(usex snmp '--enable-snmp' '' '' '') \
		$(use_enable !elibc_glibc pcreposix) \
		$(use_enable fpm) \
		$(use_enable tcp-zebra) \
		$(use_enable doc) \
		$(usex multipath $(use_enable multipath) '' '=0' '') \
		$(usex ospfapi '--enable-ospfclient' '' '' '') \
		$(use_enable readline vtysh) \
		$(use_with pam libpam) \
		$(use_enable nhrpd) \
		$(use_enable protobuf) \
		$(use_enable ipv6 ripngd) \
		$(use_enable ipv6 ospf6d) \
		$(use_enable ipv6 rtadv)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	readme.gentoo_create_doc

	keepdir /etc/quagga
	fowners root:quagga /etc/quagga
	fperms 0770 /etc/quagga

	# Install systemd-related stuff, bug #553136
	dotmpfiles "${FILESDIR}/systemd/quagga.conf"
	systemd_dounit "${FILESDIR}/systemd/zebra.service"

	# install zebra as a file, symlink the rest
	newinitd "${FILESDIR}"/quagga-services.init.3 zebra

	for service in bgpd isisd ospfd pimd ripd $(use ipv6 && echo ospf6d ripngd) $(use nhrpd && echo nhrpd); do
		dosym zebra /etc/init.d/${service}
		systemd_dounit "${FILESDIR}/systemd/${service}.service"
	done

	use readline && use pam && newpamd "${FILESDIR}/quagga.pam" quagga

	insinto /etc/logrotate.d
	newins redhat/quagga.logrotate quagga
}

pkg_postinst() {
	# Path for PIDs before first reboot should be created here, bug #558194
	tmpfiles_process quagga.conf

	readme.gentoo_print_elog
}
