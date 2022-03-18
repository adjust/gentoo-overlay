# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs prefix

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-5.1-patches/
PLEVEL="${PV##*_p}"
MY_PVN="${PV/_p/.0}"
MY_PV="${PV/_p*}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"
is_release() {
	case ${PV} in
	*_alpha*|*_beta*|*_rc*) return 1 ;;
	*) return 0 ;;
	esac
}
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	local opt=${1} plevel=${2:-${PLEVEL}} pn=${3:-${PN}} pv=${4:-${MY_PV}}
	[[ ${plevel} -eq 0 ]] && return 1
	eval set -- {1..${plevel}}
	set -- $(printf "${pn}${pv/\.}-%03d " "$@")
	if [[ ${opt} == -s ]] ; then
		echo "${@/#/${DISTDIR}/}"
	else
		local u
		for u in mirror://gnu/${pn} ftp://ftp.cwru.edu/pub/bash ; do
			printf "${u}/${pn}-${pv}-patches/%s " "$@"
		done
	fi
}

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
if is_release ; then
	SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz $(patches)"
else
	SRC_URI="ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"
fi

LICENSE="GPL-3 MIT"
SLOT="0"
[[ "${PV}" == *_rc* ]] || \
KEYWORDS="~amd64 ~arm64 ~ppc64 ~s390 ~amd64-linux ~ppc64-linux ~arm64-macos"
IUSE="afs bashlogger +elibc_musl examples mem-scramble +net nls plugins +readline +static"

MY_URI="https://github.com/robxu9/${PN}-static/releases/download/${MY_PVN}-${MUSL_VER}/bash"
# TODO: fix prefix keywords
SRC_URI+="
	amd64?		( ${MY_URI}-linux-x86_64	-> ${P}.amd64-linux-elf.bin )
	arm64?		( ${MY_URI}-linux-aarch64	-> ${P}.arm64-linux-elf.bin )
	ppc64?		( ${MY_URI}-linux-ppc64le	-> ${P}.ppc64-linux-elf.bin )
	s390?		( ${MY_URI}-linux-s390x		-> ${P}.s390-linux-elf.bin )
	amd64-linux?	( ${MY_URI}-linux-x86_64	-> ${P}.amd64-linux-elf.bin )
	ppc64-linux?	( ${MY_URI}-linux-ppc64le	-> ${P}.ppc64-linux-elf.bin )
	arm64-macos?	( ${MY_URI}-macos-aarch64	-> ${P}.arm64-macos-elf.bin )
"

RDEPEND="app-shells/bash[static]"
# We only need yacc when the .y files get patched (bash42-005, bash51-011)
BDEPEND="virtual/yacc"

S="${WORKDIR}/${MY_P}"
QA_PREBUILT="*"

src_unpack() {
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	# Include official patches
	[[ ${PLEVEL} -gt 0 ]] && eapply -p0 $(patches -s)

	# Clean out local libs so we know we use system ones w/releases.
	if is_release ; then
		rm -rf lib/{readline,termcap}/* || die
		touch lib/{readline,termcap}/Makefile.in || die # for config.status
		sed -ri -e 's:\$[{(](RL|HIST)_LIBSRC[)}]/[[:alpha:]_-]*\.h::g' Makefile.in || die
	fi

	# Prefixify hardcoded path names. No-op for non-prefix.
	hprefixify pathnames.h.in

	# Avoid regenerating docs after patches, bug #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/* || die

	eapply_user
}

src_compile() {
	emake

	if use plugins ; then
		emake -C examples/loadables all others
	fi
}

src_install() {
	local d f

	default

	dodir /bin
	# TODO: install matching bin for the arch
	cp -L "${DISTDIR}"/"${P}".amd64-linux-elf.bin "${ED}"/bin/bash || die
	# TODO: use newbin instead
	chmod +x "${ED}"/bin/bash || die
	dosym bash /bin/rbash

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

	if use plugins ; then
		exeinto /usr/$(get_libdir)/bash
		doexe $(echo examples/loadables/*.o | sed 's:\.o::g')

		insinto /usr/include/bash-plugins
		doins *.h builtins/*.h include/*.h lib/{glob/glob.h,tilde/tilde.h}
	fi

	if use examples ; then
		for d in examples/{functions,misc,scripts,startup-files} ; do
			exeinto /usr/share/doc/${PF}/${d}
			docinto ${d}
			for f in ${d}/* ; do
				if [[ ${f##*/} != PERMISSION ]] && [[ ${f##*/} != *README ]] ; then
					doexe ${f}
				else
					dodoc ${f}
				fi
			done
		done
	fi

	doman doc/*.1
	newdoc CWRU/changelog ChangeLog
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
}
