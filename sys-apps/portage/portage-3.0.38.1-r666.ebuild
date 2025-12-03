# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE='bzip2(+),threads(+)'
TMPFILES_OPTIONAL=1
# Force modern PEP517 handling for distutils-r1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1

inherit distutils-r1 linux-info toolchain-funcs tmpfiles prefix


DESCRIPTION="The package management and distribution system for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"
SRC_URI="https://gitweb.gentoo.org/proj/portage.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apidoc build doc gentoo-dev +ipc +native-extensions +rsync-verify selinux test xattr"
RESTRICT="!test? ( test )"

# Minimal safe python-exec requirement for modern behavior
DEPEND="!build? ( $(python_gen_impl_dep 'ssl(+)') )
	>=app-arch/tar-1.27
	>=dev-lang/python-exec-2.4.10
	>=sys-apps/sed-4.0.5 sys-devel/patch
	doc? ( app-text/xmlto ~app-text/docbook-xml-dtd-4.4 )
	apidoc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-epytext[${PYTHON_USEDEP}]
	)"

RDEPEND="
	acct-user/portage
	app-arch/zstd
	>=app-arch/tar-1.27
	dev-lang/python-exec:2
	>=sys-apps/findutils-4.4
	!build? (
		>=sys-apps/sed-4.0.5
		>=app-shells/bash-5.0:0[readline]
		>=app-admin/eselect-1.2
		rsync-verify? (
			>=app-portage/gemato-14.5[${PYTHON_USEDEP}]
			>=sec-keys/openpgp-keys-gentoo-release-20180706
			>=app-crypt/gnupg-2.2.4-r2[ssl(-)]
		)
	)
	elibc_glibc? ( >=sys-apps/sandbox-2.2 )
	elibc_musl? ( >=sys-apps/sandbox-2.2 )
	kernel_linux? ( sys-apps/util-linux )
	>=app-misc/pax-utils-0.1.17
	selinux? ( >=sys-libs/libselinux-2.0.94[python,${PYTHON_USEDEP}] )
	xattr? ( kernel_linux? (
		>=sys-apps/install-xattr-0.3
	) )
	!<app-admin/logrotate-3.8.0
	!<app-portage/gentoolkit-0.4.6
	!<app-portage/repoman-2.3.10
	!~app-portage/repoman-3.0.0"

PDEPEND="
	!build? (
		>=net-misc/rsync-2.6.4
		>=sys-apps/file-5.41
		>=sys-apps/coreutils-6.4
	)
"

pkg_pretend() {
	local CONFIG_CHECK="~IPC_NS ~PID_NS ~NET_NS ~UTS_NS"

	if use native-extensions && tc-is-cross-compiler; then
		einfo "Disabling USE=native-extensions for cross-compilation (bug #612158)"
	fi

	check_extra_config
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/3.0.30-silence-deprecated-profile-check.patch"
	)

	distutils-r1_python_prepare_all

	sed -e "s:^VERSION = \"HEAD\"$:VERSION = \"${PV}\":" -i lib/portage/__init__.py || die

	if use gentoo-dev; then
		einfo "Disabling --dynamic-deps by default for gentoo-dev..."
		sed -e 's:\("--dynamic-deps", \)\("y"\):\1"n":' \
			-i lib/_emerge/create_depgraph_params.py || \
			die "failed to patch create_depgraph_params.py"

		einfo "Enabling additional FEATURES for gentoo-dev..."
		echo 'FEATURES="${FEATURES} ipc-sandbox network-sandbox strict-keepdir"' \
			>> cnf/make.globals || die
	fi

	if use native-extensions && ! tc-is-cross-compiler; then
		printf "[build_ext]\nportage_ext_modules=true\n" >> setup.cfg || die
	fi

	if ! use ipc ; then
		einfo "Disabling ipc..."
		sed -e "s:_enable_ipc_daemon = True:_enable_ipc_daemon = False:" \
			-i lib/_emerge/AbstractEbuildProcess.py || \
			die "failed to patch AbstractEbuildProcess.py"
	fi

	if use xattr && use kernel_linux ; then
		einfo "Adding FEATURES=xattr to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} xattr"' >> cnf/make.globals || die "failed to append to make.globals"
	fi

	if use build || ! use rsync-verify; then
		sed -e '/^sync-rsync-verify-metamanifest/s|yes|no|' \
			-e '/^sync-webrsync-verify-signature/s|yes|no|' \
			-i cnf/repos.conf || die "sed failed"
	fi

	if [[ -n ${EPREFIX} ]] ; then
		einfo "Setting portage.const.EPREFIX ..."
		hprefixify -e "s|^(EPREFIX[[:space:]]*=[[:space:]]*\").*|\1${EPREFIX}\"|" \
			-w "/_BINARY/" lib/portage/const.py

		einfo "Prefixing shebangs ..."
		> "${T}/shebangs" || die
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "$REPLY")
			if [[ ${shebang} == "#!"* && ! ${shebang} == "#!${EPREFIX}/"* ]] ; then
				echo "${REPLY}" >> "${T}/shebangs" || die
			fi
		done < <(find . -type f -executable ! -name etc-update -print0)

		if [[ -s ${T}/shebangs ]]; then
			xargs sed -i -e "1s:^#!:#!${EPREFIX}:" < "${T}/shebangs" || die "sed failed"
		fi

		einfo "Adjusting make.globals, repos.conf and etc-update ..."
		hprefixify cnf/{make.globals,repos.conf} bin/etc-update

		if use prefix-guest ; then
			sed -e "s|^\(main-repo = \).*|\\1gentoo_prefix|" \
				-e "s|^\[gentoo\]|[gentoo_prefix]|" \
				-e "s|^\(sync-uri = \).*|\\1rsync://rsync.prefix.bitzolder.nl/gentoo-portage-prefix|" \
				-i cnf/repos.conf || die "sed failed"
		fi

		einfo "Adding FEATURES=force-prefix to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} force-prefix"' >> cnf/make.globals || die "failed to append to make.globals"
	fi

	cd "${S}/cnf" || die
	if [ -f "make.conf.example.${ARCH}".diff ]; then
		patch make.conf.example "make.conf.example.${ARCH}".diff || die "Failed to patch make.conf.example"
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
	fi
}

python_compile_all() {
	local targets=()
	use doc && targets+=( docbook )
	use apidoc && targets+=( apidoc )

	if [[ ${targets[@]} ]]; then
		esetup.py "${targets[@]}"
	fi
}

python_test() {
	esetup.py test
}

python_install() {
	# Use distutils-r1 default script locations (python-exec) and avoid
	# overriding bindir/sbindir which confuses modern python-exec behavior.
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--portage-bindir="${EPREFIX}/usr/lib/portage/${EPYTHON}" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"
}

python_install_all() {
	distutils-r1_python_install_all

	local targets=()
	use doc && targets+=(
		install_docbook
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
	)
	use apidoc && targets+=(
		install_apidoc
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
	)

	if [[ ${targets[@]} ]]; then
		esetup.py "${targets[@]}"
	fi

	dotmpfiles "${FILESDIR}"/portage-{ccache,tmpdir}.conf
}

pkg_preinst() {
	# Ensure the site-packages directory exists in the image; some build-time
	# helpers expect it to exist when running python modules during preinst.
	if ! use build; then
		python_setup
		local sitedir
		sitedir=$(python_get_sitedir)
		if [[ -z ${sitedir} ]]; then
			ewarn "Cannot determine python sitedir"
		else
			# Create the staged site-packages directory using dodir so it is
			# created under ${D} and tracked properly by the ebuild helpers.
			if [[ ! -d ${D}${sitedir} ]]; then
				einfo "Creating missing ${D}${sitedir} to satisfy preinst checks"
				dodir "${sitedir}" || mkdir -p "${D}${sitedir}" || die "failed to create ${D}${sitedir}"
			fi
		fi

		# Run compatibility upgrade helpers using the build tree on PYTHONPATH
		# so Python can import the portage package from the source directory.
		PYTHONPATH="${S}${PYTHONPATH:+:${PYTHONPATH}}" \
			"${PYTHON}" -m portage._compat_upgrade.default_locations || die

		PYTHONPATH="${S}${PYTHONPATH:+:${PYTHONPATH}}" \
			"${PYTHON}" -m portage._compat_upgrade.binpkg_compression || die

		PYTHONPATH="${S}${PYTHONPATH:+:${PYTHONPATH}}" \
			"${PYTHON}" -m portage._compat_upgrade.binpkg_multi_instance || die
	fi

	# Ensure elog dir exists to avoid logrotate error (bug #415911)
	keepdir /var/log/portage/elog
	if chown portage:portage "${ED}"/var/log/portage{,/elog} 2>/dev/null ; then
		chmod g+s,ug+rwx "${ED}"/var/log/portage{,/elog}
	fi

	if has_version "<${CATEGORY}/${PN}-2.3.77"; then
		elog "The emerge --autounmask option is now disabled by default, except for"
		elog "portions of behavior which are controlled by the --autounmask-use and"
		elog "--autounmask-license options. For backward compatibility, previous"
		elog "behavior of --autounmask=y and --autounmask=n is entirely preserved."
		elog "Users can get the old behavior simply by adding --autounmask to the"
		elog "make.conf EMERGE_DEFAULT_OPTS variable. For the rationale for this"
		elog "change, see https://bugs.gentoo.org/658648."
	fi
}
