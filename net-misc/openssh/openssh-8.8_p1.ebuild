# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver pam systemd

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="https://www.openssh.com/"
EGIT_COMMIT="e6e7d2654a13ba10141da7b42ea683ea4eeb1f38"
EGIT_COMMIT_ROOT="9d2ff50752d2c70df42699522847054ce10ef0eb"
SRC_URI="https://github.com/oasislinux/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}-${EGIT_COMMIT}.tar.gz
	https://github.com/oasislinux/root-x86_64/archive/${EGIT_COMMIT_ROOT}.tar.gz -> ${P}-root-${EGIT_COMMIT_ROOT}.tar.gz"
S="${WORKDIR}/openssh-${EGIT_COMMIT}"
MY_S="${WORKDIR}/root-x86_64-${EGIT_COMMIT_ROOT}"
QA_PREBUILT="*"
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="audit debug hpn kerberos ldns libedit livecd pam +pie +scp sctp security-key selinux ssl +static test X X509 xmss"
RESTRICT="mirror strip test"
RDEPEND="
	acct-group/sshd
	acct-user/sshd
	net-misc/openssh[static]
"

pkg_pretend() {
	# Make sure people who are using tcp wrappers are notified of its removal. #531156
	if grep -qs '^ *sshd *:' "${EROOT}"/etc/hosts.{allow,deny} ; then
		ewarn "Sorry, but openssh no longer supports tcp-wrappers, and it seems like"
		ewarn "you're trying to use it.  Update your ${EROOT}/etc/hosts.{allow,deny} please."
	fi
}

src_prepare() {
	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	sed -i \
		-e "/#UseLogin no/d" \
		"${S}"/sshd_config || die "Failed to remove removed UseLogin option (sshd_config)"

	sed -i s:libexec:$(get_libdir)/misc: sshd_config || die

	eapply_user #473004
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
}

src_install() {
	dobin contrib/ssh-copy-id "${MY_S}"/bin/{scp,sftp,ssh} \
		"${MY_S}"/bin/ssh-{add,agent,keygen,keyscan} || die
	dosbin "${MY_S}"/bin/sshd || die
	dosym ../usr/bin/ssh bin/ssh || die
	dodir /etc/ssh || die
	insinto /etc/ssh
	doins moduli ssh*_config || die
	exeinto /usr/$(get_libdir)/misc
	doexe "${MY_S}"/libexec/{sftp-server,ssh-sk-helper} || die

	fperms 600 /etc/ssh/sshd_config
	newinitd "${FILESDIR}"/sshd-r1.initd sshd || die
	newconfd "${FILESDIR}"/sshd-r1.confd sshd || die

	if use pam; then
		# TODO: check if used by anything
		newpamd "${FILESDIR}"/sshd.pam_include.2 sshd || die
	fi

	tweak_ssh_configs || die

	doman *.{1,5,8} contrib/ssh-copy-id.1 || die
	dodoc CREDITS OVERVIEW README* TODO sshd_config || die

	diropts -m 0700
	dodir /etc/skel/.ssh || die

	# https://bugs.gentoo.org/733802
	if ! use scp; then
		rm -f "${ED}"/usr/{bin/scp,share/man/man1/scp.1} \
			|| die "failed to remove scp"
	fi

	systemd_dounit "${FILESDIR}"/sshd.{service,socket} || die
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service' || die
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
	ewarn "Support for USE=pam has been dropped for net-misc/sshd[static]."
	ewarn "Make sure to update any configs that you might have."
	ewarn "You are encouraged to use dispatch-conf right now, otherwise you"
	ewarn "will not be able to establish new sessions!"
}
