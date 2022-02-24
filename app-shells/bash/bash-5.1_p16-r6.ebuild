# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs prefix unpacker

MY_PV="${PVR%_p*}-${PVR#*-r}"
MY_PN="${PN}-static"
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
SRC_URI="mirror://debian/pool/main/${P:0:1}/${PN}/${MY_P}_amd64.deb"
LICENSE="GPL-3"
RESTRICT="strip"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="afs bashlogger examples mem-scramble +net nls plugins +readline +static"
RDEPEND="app-shells/bash[static]"
S="${WORKDIR}"
QA_PREBUILT="*"

src_prepare() {
	rm -r usr/share/lintian || die
	mv bin/bash{-static,} || die
	mv usr/share/doc/bash{-static,} || die
	gunzip usr/share/{man/man1,doc/bash}/*.gz || die
	mv usr/share/doc/bash/{copyright,Copyright.txt} || die
	mv usr/share/doc/bash/{changelog,ChangeLog} || die
	mv usr/share/doc/bash/{changelog,ChangeLog}.Debian || die
	mv usr/share/man/man1/bash{-static,}.1 || die
	eapply_user # TODO: get rid of it
}

src_install() {
	local d f

	default

	dodir /bin
	into /
	dobin bin/bash || die
	dosym bash /bin/rbash || die

	insinto /etc/bash
	doins "${FILESDIR}"/bash_logout
	doins "$(prefixify_ro "${FILESDIR}"/bashrc)"

	keepdir /etc/bash/bashrc.d

	insinto /etc/skel
	for f in bash{_logout,_profile,rc} ; do
		newins "${FILESDIR}"/dot-${f} .${f}
	done

	local sed_args=(
		-e "s:#${USERLAND}#@::"
		-e '/#@/d'
	)

	if ! use readline ; then
		# bug #432338
		sed_args+=(
			-e '/^shopt -s histappend/s:^:#:'
			-e 's:use_color=true:use_color=false:'
		)
	fi

	sed -i \
		"${sed_args[@]}" \
		"${ED}"/etc/skel/.bashrc \
		"${ED}"/etc/bash/bashrc || die

	doman usr/share/man/man1/bash.1
	dodoc usr/share/doc/bash/*
}

pkg_preinst() {
	if [[ -e ${EROOT}/etc/bashrc ]] && [[ ! -d ${EROOT}/etc/bash ]] ; then
		mkdir -p "${EROOT}"/etc/bash
		mv -f "${EROOT}"/etc/bashrc "${EROOT}"/etc/bash/
	fi
}

pkg_postinst() {
	# If /bin/sh does not exist, provide it
	if [[ ! -e ${EROOT}/bin/sh ]] ; then
		ln -sf bash "${EROOT}"/bin/sh
	fi
	# We are not bug compatible :kekw:
	ewarn "You might experience your profile not getting sourced (eg no colors)"
	ewarn "if for some reason your login shell being run without '--login'."
	ewarn "Consider actually running your login shell with '--login' to fix this."
	ewarn "Alternatively you can source your profile from bashrc as a workaround:"
	ewarn "\`echo >> \"\${HOME}\"/.bashrc source /etc/profile\`"
}
