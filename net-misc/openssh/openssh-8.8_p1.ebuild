# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user-info flag-o-matic autotools pam systemd toolchain-funcs

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="https://www.openssh.com/"
EGIT_COMMIT="e6e7d2654a13ba10141da7b42ea683ea4eeb1f38"
EGIT_COMMIT_ROOT="9d2ff50752d2c70df42699522847054ce10ef0eb"
EGIT_COMMIT_ETC="fbab9474562865d48d9d1f7194eb8b3f0fb9651e"
SRC_URI="https://github.com/oasislinux/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}-${EGIT_COMMIT}.tar.gz
	https://github.com/oasislinux/root-x86_64/archive/${EGIT_COMMIT_ROOT}.tar.gz -> ${P}-root-${EGIT_COMMIT_ROOT}.tar.gz
	https://github.com/oasislinux/etc/archive/${EGIT_COMMIT_ETC}.tar.gz -> ${P}-etc-${EGIT_COMMIT_ETC}.tar.gz"
S="${WORKDIR}/openssh-${EGIT_COMMIT}"
MY_S="${WORKDIR}/root-x86_64-${EGIT_COMMIT_ROOT}"
MY_S_ETC="${WORKDIR}/etc-${EGIT_COMMIT_ETC}"
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="abi_mips_n32 audit debug hpn kerberos ldns libedit livecd pam +pie +scp sctp security-key selinux ssl +static test X X509 xmss"
RESTRICT="mirror test"

RDEPEND="
	acct-group/sshd
	acct-user/sshd
	net-misc/openssh[static]
"
RDEPEND="${RDEPEND}
	!prefix? ( sys-apps/shadow )
	X? ( x11-apps/xauth )
"
BDEPEND="
	virtual/pkgconfig
	sys-devel/autoconf
"

pkg_pretend() {
	# this sucks, but i'd rather have people unable to `emerge -u openssh`
	# than not be able to log in to their server any more
	local missing=()
	check_feature() { use "${1}" && [[ -z ${!2} ]] && missing+=( "${1}" ); }
	if [[ ${#missing[@]} -ne 0 ]] ; then
		eerror "Sorry, but this version does not yet support features"
		eerror "that you requested: ${missing[*]}"
		eerror "Please mask ${PF} for now and check back later:"
		eerror " # echo '=${CATEGORY}/${PF}' >> /etc/portage/package.mask"
		die "Missing requested third party patch."
	fi

	# Make sure people who are using tcp wrappers are notified of its removal. #531156
	if grep -qs '^ *sshd *:' "${EROOT}"/etc/hosts.{allow,deny} ; then
		ewarn "Sorry, but openssh no longer supports tcp-wrappers, and it seems like"
		ewarn "you're trying to use it.  Update your ${EROOT}/etc/hosts.{allow,deny} please."
	fi
}

src_prepare() {
	sed -i \
		-e "/_PATH_XAUTH/s:/usr/X11R6/bin/xauth:${EPREFIX}/usr/bin/xauth:" \
		pathnames.h || die

	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	eapply "${FILESDIR}"/${PN}-7.9_p1-include-stdlib.patch
	eapply "${FILESDIR}"/${PN}-8.7_p1-GSSAPI-dns.patch #165444 integrated into gsskex
	eapply "${FILESDIR}"/${PN}-7.5_p1-disable-conch-interop-tests.patch
	eapply "${FILESDIR}"/${PN}-8.0_p1-fix-putty-tests.patch
	eapply "${FILESDIR}"/${PN}-8.0_p1-deny-shmget-shmat-shmdt-in-preauth-privsep-child.patch

	[[ -d ${WORKDIR}/patches ]] && eapply "${WORKDIR}"/patches

	local PATCHSET_VERSION_MACROS=()

	sed -i \
		-e "/#UseLogin no/d" \
		"${S}"/sshd_config || die "Failed to remove removed UseLogin option (sshd_config)"

	eapply_user #473004

	# These tests are currently incompatible with PORTAGE_TMPDIR/sandbox
	sed -e '/\t\tpercent \\/ d' \
		-i regress/Makefile || die

	tc-export PKG_CONFIG
	local sed_args=(
		# Disable PATH reset, trust what portage gives us #254615
		-e 's:^PATH=/:#PATH=/:'
		# Disable fortify flags ... our gcc does this for us
		-e 's:-D_FORTIFY_SOURCE=2::'
	)

	# The -ftrapv flag ICEs on hppa #505182
	use hppa && sed_args+=(
		-e '/CFLAGS/s:-ftrapv:-fdisable-this-test:'
		-e '/OSSH_CHECK_CFLAG_LINK.*-ftrapv/d'
	)
	# _XOPEN_SOURCE causes header conflicts on Solaris
	[[ ${CHOST} == *-solaris* ]] && sed_args+=(
		-e 's/-D_XOPEN_SOURCE//'
	)
	sed -i "${sed_args[@]}" configure{.ac,} || die

	eautoreconf
}

src_configure() {
	addwrite /dev/ptmx

	use debug && append-cppflags -DSANDBOX_SECCOMP_FILTER_DEBUG

	if [[ ${CHOST} == *-solaris* ]] ; then
		# Solaris' glob.h doesn't have things like GLOB_TILDE, configure
		# doesn't check for this, so force the replacement to be put in
		# place
		append-cppflags -DBROKEN_GLOB
	fi

	# use replacement, RPF_ECHO_ON doesn't exist here
	[[ ${CHOST} == *-darwin* ]] && export ac_cv_func_readpassphrase=no

	local myconf=(
		--with-ldflags="${LDFLAGS}"
		--disable-strip
		--with-pid-dir="${EPREFIX}"$(usex kernel_linux '' '/var')/run
		--sysconfdir="${EPREFIX}"/etc/ssh
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/misc
		--datadir="${EPREFIX}"/usr/share/openssh
		--with-privsep-path="${EPREFIX}"/var/empty
		--with-privsep-user=sshd
		$(use_with audit audit linux)
		$(use_with ldns ldns "${EPREFIX}"/usr)
		$(use_with libedit)
		$(use_with pie)
		$(use_with selinux)
		$(use_with !elibc_Cygwin hardening) #659210
	)

	if use elibc_musl; then
		# musl defines bogus values for UTMP_FILE and WTMP_FILE
		# https://bugs.gentoo.org/753230
		myconf+=( --disable-utmp --disable-wtmp )
	fi

	# The seccomp sandbox is broken on x32, so use the older method for now. #553748
	use amd64 && [[ ${ABI} == "x32" ]] && myconf+=( --with-sandbox=rlimit )

	econf "${myconf[@]}"
}

src_test() {
	local tests=( compat-tests )
	local shell=$(egetshell "${UID}")
	if [[ ${shell} == */nologin ]] || [[ ${shell} == */false ]] ; then
		ewarn "Running the full OpenSSH testsuite requires a usable shell for the 'portage'"
		ewarn "user, so we will run a subset only."
		tests+=( interop-tests )
	else
		tests+=( tests )
	fi

	local -x SUDO= SSH_SK_PROVIDER= TEST_SSH_UNSAFE_PERMISSIONS=1
	mkdir -p "${HOME}"/.ssh || die
}

# Gentoo tweaks to default config files.
tweak_ssh_configs() {
	local locale_vars=(
		# These are language variables that POSIX defines.
		# http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08_02
		LANG LC_ALL LC_COLLATE LC_CTYPE LC_MESSAGES LC_MONETARY LC_NUMERIC LC_TIME

		# These are the GNU extensions.
		# https://www.gnu.org/software/autoconf/manual/html_node/Special-Shell-Variables.html
		LANGUAGE LC_ADDRESS LC_IDENTIFICATION LC_MEASUREMENT LC_NAME LC_PAPER LC_TELEPHONE
	)

	# First the server config.
	cat <<-EOF >> "${ED}"/etc/ssh/sshd_config

	# Allow client to pass locale environment variables. #367017
	AcceptEnv ${locale_vars[*]}

	# Allow client to pass COLORTERM to match TERM. #658540
	AcceptEnv COLORTERM
	EOF

	# Then the client config.
	cat <<-EOF >> "${ED}"/etc/ssh/ssh_config

	# Send locale environment variables. #367017
	SendEnv ${locale_vars[*]}

	# Send COLORTERM to match TERM. #658540
	SendEnv COLORTERM
	EOF

	if use pam ; then
		# TODO: fix config file regarding to pam
		sed -i \
			-e "/^#UsePAM /s:.*:UsePAM yes:" \
			-e "/^#PasswordAuthentication /s:.*:PasswordAuthentication no:" \
			-e "/^#PrintMotd /s:.*:PrintMotd no:" \
			-e "/^#PrintLastLog /s:.*:PrintLastLog no:" \
			"${ED}"/etc/ssh/sshd_config || die
	fi

	if use livecd ; then
		sed -i \
			-e '/^#PermitRootLogin/c# Allow root login with password on livecds.\nPermitRootLogin Yes' \
			"${ED}"/etc/ssh/sshd_config || die
	fi
}

src_install() {
	dobin "${MY_S}"/bin/{scp,sftp,ssh,ssh-add,ssh-agent,ssh-keygen,ssh-keyscan} || die
	dosbin "${MY_S}"/bin/sshd
	dodir /etc/ssh || die
	insinto /etc/ssh
	doins moduli ssh*_config || die
	doman *.{1,5,8} || die
	exeinto /usr/$(get_libdir)/misc
	doexe "${MY_S}"/libexec/{sftp-server,ssh-sk-helper} || die

	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	newinitd "${FILESDIR}"/sshd-r1.initd sshd
	newconfd "${FILESDIR}"/sshd-r1.confd sshd

	if use pam; then
		newpamd "${FILESDIR}"/sshd.pam_include.2 sshd
	fi

	tweak_ssh_configs

	doman contrib/ssh-copy-id.1
	dodoc CREDITS OVERVIEW README* TODO sshd_config

	diropts -m 0700
	dodir /etc/skel/.ssh

	# https://bugs.gentoo.org/733802
	if ! use scp; then
		rm -f "${ED}"/usr/{bin/scp,share/man/man1/scp.1} \
			|| die "failed to remove scp"
	fi

	rmdir "${ED}"/var/empty || die

	systemd_dounit "${FILESDIR}"/sshd.{service,socket}
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service'
}

pkg_postinst() {
	local old_ver
	for old_ver in ${REPLACING_VERSIONS}; do
		if ver_test "${old_ver}" -lt "5.8_p1"; then
			elog "Starting with openssh-5.8p1, the server will default to a newer key"
			elog "algorithm (ECDSA).  You are encouraged to manually update your stored"
			elog "keys list as servers update theirs.  See ssh-keyscan(1) for more info."
		fi
		if ver_test "${old_ver}" -lt "7.0_p1"; then
			elog "Starting with openssh-6.7, support for USE=tcpd has been dropped by upstream."
			elog "Make sure to update any configs that you might have.  Note that xinetd might"
			elog "be an alternative for you as it supports USE=tcpd."
		fi
		if ver_test "${old_ver}" -lt "7.1_p1"; then #557388 #555518
			elog "Starting with openssh-7.0, support for ssh-dss keys were disabled due to their"
			elog "weak sizes.  If you rely on these key types, you can re-enable the key types by"
			elog "adding to your sshd_config or ~/.ssh/config files:"
			elog "	PubkeyAcceptedKeyTypes=+ssh-dss"
			elog "You should however generate new keys using rsa or ed25519."

			elog "Starting with openssh-7.0, the default for PermitRootLogin changed from 'yes'"
			elog "to 'prohibit-password'.  That means password auth for root users no longer works"
			elog "out of the box.  If you need this, please update your sshd_config explicitly."
		fi
		if ver_test "${old_ver}" -lt "7.6_p1"; then
			elog "Starting with openssh-7.6p1, openssh upstream has removed ssh1 support entirely."
			elog "Furthermore, rsa keys with less than 1024 bits will be refused."
		fi
		if ver_test "${old_ver}" -lt "7.7_p1"; then
			elog "Starting with openssh-7.7p1, we no longer patch openssh to provide LDAP functionality."
			elog "Install sys-auth/ssh-ldap-pubkey and use OpenSSH's \"AuthorizedKeysCommand\" option"
			elog "if you need to authenticate against LDAP."
			elog "See https://wiki.gentoo.org/wiki/SSH/LDAP_migration for more details."
		fi
		if ver_test "${old_ver}" -lt "8.2_p1"; then
			ewarn "After upgrading to openssh-8.2p1 please restart sshd, otherwise you"
			ewarn "will not be able to establish new sessions. Restarting sshd over a ssh"
			ewarn "connection is generally safe."
		fi
	done
}
