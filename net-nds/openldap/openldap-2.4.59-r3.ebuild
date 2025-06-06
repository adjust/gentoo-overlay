# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Re cleanups:
# 2.5.x is an LTS release so we want to keep it for a while.

inherit autotools db-use flag-o-matic multilib multilib-minimal preserve-libs ssl-cert toolchain-funcs systemd tmpfiles

BIS_PN=rfc2307bis.schema
BIS_PV=20140524
BIS_P="${BIS_PN}-${BIS_PV}"

DESCRIPTION="LDAP suite of application and development tools"
HOMEPAGE="https://www.openldap.org/"

# upstream mirrors are mostly not working, using canonical URI
SRC_URI="
	https://openldap.org/software/download/OpenLDAP/openldap-release/${P}.tgz
	http://gpl.savoirfairelinux.net/pub/mirrors/openldap/openldap-release/${P}.tgz
	http://repository.linagora.org/OpenLDAP/openldap-release/${P}.tgz
	http://mirror.eu.oneandone.net/software/openldap/openldap-release/${P}.tgz
	mirror://gentoo/${BIS_P}"

LICENSE="OPENLDAP GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

IUSE_DAEMON="crypt samba tcpd experimental minimal"
IUSE_BACKEND="+berkdb"
IUSE_OVERLAY="overlays perl"
IUSE_OPTIONAL="gnutls iodbc sasl ssl odbc debug ipv6 +syslog selinux static-libs test"
IUSE_CONTRIB="smbkrb5passwd kerberos kinit pbkdf2 sha2"
IUSE_CONTRIB="${IUSE_CONTRIB} cxx"
IUSE="${IUSE_DAEMON} ${IUSE_BACKEND} ${IUSE_OVERLAY} ${IUSE_OPTIONAL} ${IUSE_CONTRIB}"
REQUIRED_USE="cxx? ( sasl )
	pbkdf2? ( ssl )
	test? ( berkdb )
	?? ( test minimal )
	kerberos? ( ?? ( kinit smbkrb5passwd ) )"
RESTRICT="!test? ( test )"

# always list newer first
# Do not add any AGPL-3 BDB here!
# See bug 525110, comment 15.
# Advanced usage: OPENLDAP_BDB_SLOTS in the environment can be used to force a slot during build.
BDB_SLOTS="${OPENLDAP_BDB_SLOTS:=5.3 4.8}"
BDB_PKGS=''
for _slot in $BDB_SLOTS; do BDB_PKGS="${BDB_PKGS} sys-libs/db:${_slot}" ; done

# openssl is needed to generate lanman-passwords required by samba
COMMON_DEPEND="
	ssl? (
		!gnutls? (
			>=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}]
		)
		gnutls? (
			>=net-libs/gnutls-2.12.23-r6:=[${MULTILIB_USEDEP}]
			>=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
		)
	)
	sasl? ( dev-libs/cyrus-sasl:= )
	!minimal? (
		dev-libs/libltdl
		sys-fs/e2fsprogs
		>=dev-db/lmdb-0.9.18:=
		crypt? ( virtual/libcrypt:= )
		tcpd? ( sys-apps/tcp-wrappers )
		odbc? ( !iodbc? ( dev-db/unixODBC )
			iodbc? ( dev-db/libiodbc ) )
		perl? ( dev-lang/perl:=[-build(-)] )
		samba? (
			dev-libs/openssl:0=
		)
		berkdb? (
			<sys-libs/db-6.0:=
			|| ( ${BDB_PKGS} )
			)
		smbkrb5passwd? (
			dev-libs/openssl:0=
			kerberos? ( app-crypt/heimdal )
			)
		kerberos? (
			virtual/krb5
			kinit? ( !app-crypt/heimdal )
			)
		cxx? ( dev-libs/cyrus-sasl:= )
	)
"
DEPEND="${COMMON_DEPEND}
	sys-apps/groff
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-ldap )
"

# The user/group are only used for running daemons which are
# disabled in minimal builds, so elide the accounts too.
BDEPEND="!minimal? (
		acct-group/ldap
		acct-user/ldap
)
"

# for tracking versions
OPENLDAP_VERSIONTAG=".version-tag"
OPENLDAP_DEFAULTDIR_VERSIONTAG="/var/lib/openldap-data"

MULTILIB_WRAPPED_HEADERS=(
	# USE=cxx
	/usr/include/LDAPAsynConnection.h
	/usr/include/LDAPAttrType.h
	/usr/include/LDAPAttribute.h
	/usr/include/LDAPAttributeList.h
	/usr/include/LDAPConnection.h
	/usr/include/LDAPConstraints.h
	/usr/include/LDAPControl.h
	/usr/include/LDAPControlSet.h
	/usr/include/LDAPEntry.h
	/usr/include/LDAPEntryList.h
	/usr/include/LDAPException.h
	/usr/include/LDAPExtResult.h
	/usr/include/LDAPMessage.h
	/usr/include/LDAPMessageQueue.h
	/usr/include/LDAPModList.h
	/usr/include/LDAPModification.h
	/usr/include/LDAPObjClass.h
	/usr/include/LDAPRebind.h
	/usr/include/LDAPRebindAuth.h
	/usr/include/LDAPReferenceList.h
	/usr/include/LDAPResult.h
	/usr/include/LDAPSaslBindResult.h
	/usr/include/LDAPSchema.h
	/usr/include/LDAPSearchReference.h
	/usr/include/LDAPSearchResult.h
	/usr/include/LDAPSearchResults.h
	/usr/include/LDAPUrl.h
	/usr/include/LDAPUrlList.h
	/usr/include/LdifReader.h
	/usr/include/LdifWriter.h
	/usr/include/SaslInteraction.h
	/usr/include/SaslInteractionHandler.h
	/usr/include/StringList.h
	/usr/include/TlsOptions.h
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.17-gcc44.patch

	"${FILESDIR}"/${PN}-2.2.14-perlthreadsfix.patch
	"${FILESDIR}"/${PN}-2.4.15-ppolicy.patch

	# bug #116045 - still present in 2.4.28
	"${FILESDIR}"/${PN}-2.4.35-contrib-smbk5pwd.patch
	# bug #408077 - samba4
	"${FILESDIR}"/${PN}-2.4.35-contrib-samba4.patch

	# bug #189817
	"${FILESDIR}"/${PN}-2.4.11-libldap_r.patch

	# bug #233633
	"${FILESDIR}"/${PN}-2.4.45-fix-lmpasswd-gnutls-symbols.patch

	# bug #281495
	"${FILESDIR}"/${PN}-2.4.28-gnutls-gcrypt.patch

	# bug #294350
	"${FILESDIR}"/${PN}-2.4.6-evolution-ntlm.patch

	# unbreak /bin/sh -> dash
	"${FILESDIR}"/${PN}-2.4.28-fix-dash.patch

	# bug #420959
	"${FILESDIR}"/${PN}-2.4.31-gcc47.patch

	# unbundle lmdb
	"${FILESDIR}"/${PN}-2.4.42-mdb-unbundle.patch

	# fix some compiler warnings
	"${FILESDIR}"/${PN}-2.4.47-warnings.patch

	# Atexit segfault
	"${FILESDIR}"/${PN}-2.4.59-atexit-fix.patch

	# implicit function defs
	"${FILESDIR}"/${PN}-2.6.1-cloak.patch
	"${FILESDIR}"/${PN}-2.4.59-implicit-function.patch
)

openldap_filecount() {
	local dir="$1"
	find "${dir}" -type f ! -name '.*' ! -name 'DB_CONFIG*' | wc -l
}

openldap_find_versiontags() {
	# scan for all datadirs
	local openldap_datadirs=()
	if [[ -f "${EROOT}"/etc/openldap/slapd.conf ]]; then
		openldap_datadirs=( $(awk '{if($1 == "directory") print $2 }' "${EROOT}"/etc/openldap/slapd.conf) )
	fi
	openldap_datadirs+=( ${OPENLDAP_DEFAULTDIR_VERSIONTAG} )

	einfo
	einfo "Scanning datadir(s) from slapd.conf and"
	einfo "the default installdir for Versiontags"
	einfo "(${OPENLDAP_DEFAULTDIR_VERSIONTAG} may appear twice)"
	einfo

	# scan datadirs if we have a version tag
	openldap_found_tag=0
	have_files=0
	for each in ${openldap_datadirs[@]} ; do
		CURRENT_TAGDIR="${ROOT}$(sed "s:\/::" <<< ${each})"
		CURRENT_TAG="${CURRENT_TAGDIR}/${OPENLDAP_VERSIONTAG}"
		if [[ -d "${CURRENT_TAGDIR}" ]] && [[ "${openldap_found_tag}" == 0 ]] ; then
			einfo "- Checking ${each}..."
			if [[ -r "${CURRENT_TAG}" ]] ; then
				# yey, we have one :)
				einfo "   Found Versiontag in ${each}"
				source "${CURRENT_TAG}"
				if [[ "${OLDPF}" == "" ]] ; then
					eerror "Invalid Versiontag found in ${CURRENT_TAGDIR}"
					eerror "Please delete it"
					eerror
					die "Please kill the invalid versiontag in ${CURRENT_TAGDIR}"
				fi

				OLD_MAJOR=$(ver_cut 2-3 ${OLDPF})

				[[ "$(openldap_filecount ${CURRENT_TAGDIR})" -gt 0 ]] && have_files=1

				# are we on the same branch?
				if [[ "${OLD_MAJOR}" != "${PV:0:3}" ]] ; then
					ewarn "   Versiontag doesn't match current major release!"
					if [[ "${have_files}" == "1" ]] ; then
						eerror "   Versiontag says other major and you (probably) have datafiles!"
						echo
						openldap_upgrade_howto
					else
						einfo "   No real problem, seems there's no database."
					fi
				else
					einfo "   Versiontag is fine here :)"
				fi
			else
				einfo "   Non-tagged dir ${each}"
				[[ "$(openldap_filecount ${each})" -gt 0 ]] && have_files=1
				if [[ "${have_files}" == "1" ]] ; then
					einfo "   EEK! Non-empty non-tagged datadir, counting `ls -a ${each} | wc -l` files"
					echo

					eerror
					eerror "Your OpenLDAP Installation has a non tagged datadir that"
					eerror "possibly contains a database at ${CURRENT_TAGDIR}"
					eerror
					eerror "Please export data if any entered and empty or remove"
					eerror "the directory, installation has been stopped so you"
					eerror "can take required action"
					eerror
					eerror "For a HOWTO on exporting the data, see instructions in the ebuild"
					eerror
					openldap_upgrade_howto
					die "Please move the datadir ${CURRENT_TAGDIR} away"
				fi
			fi
			einfo
		fi
	done
	[[ "${have_files}" == "1" ]] && einfo "DB files present" || einfo "No DB files present"

	# Now we must check for the major version of sys-libs/db linked against.
	SLAPD_PATH="${EROOT}/usr/$(get_libdir)/openldap/slapd"
	if [[ "${have_files}" == "1" ]] && [[ -f "${SLAPD_PATH}" ]]; then
		OLDVER="$(/usr/bin/ldd ${SLAPD_PATH} \
			| awk '/libdb-/{gsub("^libdb-","",$1);gsub(".so$","",$1);print $1}')"
		if use berkdb; then
			# find which one would be used
			for bdb_slot in ${BDB_SLOTS} ; do
				NEWVER="$(db_findver "=sys-libs/db-${bdb_slot}*")"
				[[ -n "${NEWVER}" ]] && break
			done
		fi
		local fail=0
		if [[ -z "${OLDVER}" ]] && [[ -z "${NEWVER}" ]]; then
			:
			# Nothing wrong here.
		elif [[ -z "${OLDVER}" ]] && [[ -n "${NEWVER}" ]]; then
			eerror "	Your existing version of OpenLDAP was not built against"
			eerror "	any version of sys-libs/db, but the new one will build"
			eerror "	against	${NEWVER} and your database may be inaccessible."
			echo
			fail=1
		elif [[ -n "${OLDVER}" ]] && [[ -z "${NEWVER}" ]]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will not be"
			eerror "	built against any version and your database may be"
			eerror "	inaccessible."
			echo
			fail=1
		elif [[ "${OLDVER}" != "${NEWVER}" ]]; then
			eerror "	Your existing version of OpenLDAP was built against"
			eerror "	sys-libs/db:${OLDVER}, but the new one will build against"
			eerror "	${NEWVER} and your database would be inaccessible."
			echo
			fail=1
		fi
		[[ "${fail}" == "1" ]] && openldap_upgrade_howto
	fi

	echo
	einfo
	einfo "All datadirs are fine, proceeding with merge now..."
	einfo
}

openldap_upgrade_howto() {
	local d l i
	eerror
	eerror "A (possible old) installation of OpenLDAP was detected,"
	eerror "installation will not proceed for now."
	eerror
	eerror "As major version upgrades can corrupt your database,"
	eerror "you need to dump your database and re-create it afterwards."
	eerror
	eerror "Additionally, rebuilding against different major versions of the"
	eerror "sys-libs/db libraries will cause your database to be inaccessible."
	eerror ""
	d="$(date -u +%s)"
	l="/root/ldapdump.${d}"
	i="${l}.raw"
	eerror " 1. /etc/init.d/slapd stop"
	eerror " 2. slapcat -l ${i}"
	eerror " 3. grep -E -v '^(entry|context)CSN:' <${i} >${l}"
	eerror " 4. mv /var/lib/openldap-data/ /var/lib/openldap-data-backup/"
	eerror " 5. emerge --update \=net-nds/${PF}"
	eerror " 6. etc-update, and ensure that you apply the changes"
	eerror " 7. slapadd -l ${l}"
	eerror " 8. chown ldap:ldap /var/lib/openldap-data/*"
	eerror " 9. /etc/init.d/slapd start"
	eerror "10. check that your data is intact."
	eerror "11. set up the new replication system."
	eerror
	if [[ "${FORCE_UPGRADE}" != "1" ]]; then
		die "You need to upgrade your database first"
	else
		eerror "You have the magical FORCE_UPGRADE=1 in place."
		eerror "Don't say you weren't warned about data loss."
	fi
}

pkg_setup() {
	if ! use sasl && use cxx ; then
		die "To build the ldapc++ library you must emerge openldap with sasl support"
	fi
	# Bug #322787
	if use minimal && ! has_version "net-nds/openldap" ; then
		einfo "No datadir scan needed, openldap not installed"
	elif use minimal && has_version 'net-nds/openldap[minimal]' ; then
		einfo "Skipping scan for previous datadirs as requested by minimal useflag"
	else
		openldap_find_versiontags
	fi
}

src_prepare() {
	# ensure correct SLAPI path by default
	sed -e 's,\(#define LDAPI_SOCK\).*,\1 "'"${EPREFIX}"'/var/run/openldap/slapd.sock",' \
		-i include/ldap_defaults.h || die

	default
	rm -r libraries/liblmdb || die

	pushd build &>/dev/null || die "pushd build"
	einfo "Making sure upstream build strip does not do stripping too early"
	sed -i.orig \
		-e '/^STRIP/s,-s,,g' \
		top.mk || die "Failed to block stripping"
	popd &>/dev/null || die

	# wrong assumption that /bin/sh is /bin/bash
	sed \
		-e 's|/bin/sh|/bin/bash|g' \
		-i tests/scripts/* || die "sed failed"

	if test -e configure.in -a ! -e configure.ac ; then
		mv -f configure.in configure.ac
	fi

	# Required for autoconf-2.70 #765043
	sed 's@^AM_INIT_AUTOMAKE.*@AC_PROG_MAKE_SET@' -i configure.ac || die
	AT_NOEAUTOMAKE=yes eautoreconf
}

build_contrib_module() {
	# <dir> <sources> <outputname>
	pushd "${S}/contrib/slapd-modules/$1" &>/dev/null || die "pushd contrib/slapd-modules/$1"
	einfo "Compiling contrib-module: $3"
	# Make sure it's uppercase
	local define_name="$(LC_ALL=C tr '[:lower:]' '[:upper:]' <<< "SLAPD_OVER_${1}")"
	"${lt}" --mode=compile --tag=CC \
		"${CC}" \
		-D${define_name}=SLAPD_MOD_DYNAMIC \
		-I"${BUILD_DIR}"/include \
		-I../../../include -I../../../servers/slapd ${CFLAGS} \
		-o ${2%.c}.lo -c $2 || die "compiling $3 failed"
	einfo "Linking contrib-module: $3"
	"${lt}" --mode=link --tag=CC \
		"${CC}" -module \
		${CFLAGS} \
		${LDFLAGS} \
		-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
		-o $3.la ${2%.c}.lo || die "linking $3 failed"
	popd &>/dev/null || die
}

src_configure() {
	if use experimental ; then
		# connectionless ldap per bug #342439
		# connectionless is a unsupported feature according to Howard Chu
		# see https://bugs.openldap.org/show_bug.cgi?id=9739
		# (see also bug #892009)
		append-flags -DLDAP_CONNECTIONLESS
	fi

	# The configure scripts make some assumptions that aren't valid in newer GCC.
	# https://bugs.gentoo.org/920380
	append-flags $(test-flags-CC -Wno-error=implicit-int)
	# conftest.c:113:16: error: passing argument 1 of 'pthread_detach' makes
	# integer from pointer without a cast [-Wint-conversion]
	append-flags $(test-flags-CC -Wno-error=int-conversion)
	# error: passing argument 3 of ‘ldap_bv2rdn’ from incompatible pointer type
	# [-Wincompatible-pointer-types]
	# expected ‘char **’ but argument is of type ‘const char **’
	append-flags $(test-flags-CC -Wno-error=incompatible-pointer-types)

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=()

	use debug && myconf+=( $(use_enable debug) )

	# ICU exists only in the configure, nowhere in the codebase, bug #510858
	export ac_cv_header_unicode_utypes_h=no ol_cv_lib_icu=no

	if ! use minimal && multilib_is_native_abi; then
		local CPPFLAGS=${CPPFLAGS}

		# re-enable serverside overlay chains per bug #296567
		# see ldap docs chaper 12.3.1 for details
		myconf+=( --enable-ldap )

		# backends
		myconf+=( --enable-slapd )
		if use berkdb ; then
			einfo "Using Berkeley DB for local backend"
			myconf+=( --enable-bdb --enable-hdb )
			DBINCLUDE=$(db_includedir ${BDB_SLOTS})
			einfo "Using ${DBINCLUDE} for sys-libs/db version"
			# We need to include the slotted db.h dir for FreeBSD
			append-cppflags -I${DBINCLUDE}
		else
			myconf+=( --disable-bdb --disable-hdb )
		fi
		for backend in dnssrv ldap mdb meta monitor null passwd relay shell sock; do
			myconf+=( --enable-${backend}=mod )
		done

		myconf+=( $(use_enable perl perl mod) )

		myconf+=( $(use_enable odbc sql mod) )
		if use odbc ; then
			local odbc_lib="unixodbc"
			if use iodbc ; then
				odbc_lib="iodbc"
				append-cppflags -I"${EPREFIX}"/usr/include/iodbc
			fi
			myconf+=( --with-odbc=${odbc_lib} )
		fi

		# slapd options
		myconf+=(
			$(use_enable crypt)
			--disable-slp
			$(use_enable samba lmpasswd)
			$(use_enable syslog)
		)
		if use experimental ; then
			myconf+=(
				--enable-dynacl
				--enable-aci=mod
			)
		fi
		for option in aci cleartext modules rewrite rlookups slapi; do
			myconf+=( --enable-${option} )
		done

		# slapd overlay options
		# Compile-in the syncprov, the others as module
		myconf+=( --enable-syncprov=yes )
		use overlays && myconf+=( --enable-overlays=mod )

	else
		myconf+=(
			--disable-backends
			--disable-slapd
			--disable-bdb
			--disable-hdb
			--disable-mdb
			--disable-overlays
			--disable-syslog
		)
	fi

	# basic functionality stuff
	myconf+=(
		$(use_enable ipv6)
		$(multilib_native_use_with sasl cyrus-sasl)
		$(multilib_native_use_enable sasl spasswd)
		$(use_enable tcpd wrappers)
	)

	# Some cross-compiling tests don't pan out well.
	tc-is-cross-compiler && myconf+=(
		--with-yielding-select=yes
	)

	local ssl_lib="no"
	if use ssl || ( ! use minimal && use samba ) ; then
		ssl_lib="openssl"
		use gnutls && ssl_lib="gnutls"
	fi

	myconf+=( --with-tls=${ssl_lib} )

	for basicflag in dynamic local proctitle shared; do
		myconf+=( --enable-${basicflag} )
	done

	tc-export AR CC CXX
	CONFIG_SHELL="/bin/sh" \
	ECONF_SOURCE="${S}" \
	STRIP=/bin/true \
	econf \
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/openldap \
		$(use_enable static-libs static) \
		"${myconf[@]}"
	emake depend
}

src_configure_cxx() {
	# This needs the libraries built by the first build run.
	# So we have to run it AFTER the main build, not just after the main
	# configure.
	local myconf_ldapcpp=(
		--with-ldap-includes="${S}"/include
	)

	mkdir -p "${BUILD_DIR}"/contrib/ldapc++ || die
	pushd "${BUILD_DIR}/contrib/ldapc++" &>/dev/null || die "pushd contrib/ldapc++"

	local LDFLAGS=${LDFLAGS} CPPFLAGS=${CPPFLAGS}
	append-ldflags -L"${BUILD_DIR}"/libraries/liblber/.libs \
		-L"${BUILD_DIR}"/libraries/libldap/.libs
	append-cppflags -I"${BUILD_DIR}"/include
	ECONF_SOURCE=${S}/contrib/ldapc++ \
	econf "${myconf_ldapcpp[@]}" \
		CC="${CC}" \
		CXX="${CXX}"
	popd &>/dev/null || die
}

multilib_src_compile() {
	tc-export AR CC CXX
	emake CC="${CC}" AR="${AR}" SHELL="${EPREFIX}"/bin/sh
	local lt="${BUILD_DIR}/libtool"
	export echo="echo"

	if ! use minimal && multilib_is_native_abi ; then
		if use cxx ; then
			einfo "Building contrib library: ldapc++"
			src_configure_cxx
			pushd "${BUILD_DIR}/contrib/ldapc++" &>/dev/null || die "pushd contrib/ldapc++"
			emake CC="${CC}" CXX="${CXX}"
			popd &>/dev/null || die
		fi

		if use smbkrb5passwd ; then
			einfo "Building contrib-module: smbk5pwd"
			pushd "${S}/contrib/slapd-modules/smbk5pwd" &>/dev/null || die "pushd contrib/slapd-modules/smbk5pwd"

			MY_DEFS="-DDO_SHADOW"
			if use samba ; then
				MY_DEFS="${MY_DEFS} -DDO_SAMBA"
				MY_KRB5_INC=""
			fi
			if use kerberos ; then
				MY_DEFS="${MY_DEFS} -DDO_KRB5"
				MY_KRB5_INC="$(krb5-config --cflags)"
			fi

			emake \
				DEFS="${MY_DEFS}" \
				KRB5_INC="${MY_KRB5_INC}" \
				LDAP_BUILD="${BUILD_DIR}" \
				CC="${CC}" libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap"
			popd &>/dev/null || die
		fi

		if use overlays ; then
			einfo "Building contrib-module: samba4"
			pushd "${S}/contrib/slapd-modules/samba4" &>/dev/null || die "pushd contrib/slapd-modules/samba4"

			emake \
				LDAP_BUILD="${BUILD_DIR}" \
				CC="${CC}" libexecdir="/usr/$(get_libdir)/openldap"
			popd &>/dev/null || die
		fi

		if use kerberos ; then
			if use kinit ; then
				build_contrib_module "kinit" "kinit.c" "kinit"
			fi
			pushd "${S}/contrib/slapd-modules/passwd" &>/dev/null || die "pushd contrib/slapd-modules/passwd"
			einfo "Compiling contrib-module: pw-kerberos"
			"${lt}" --mode=compile --tag=CC \
				"${CC}" \
				-I"${BUILD_DIR}"/include \
				-I../../../include \
				${CFLAGS} \
				$(krb5-config --cflags) \
				-DHAVE_KRB5 \
				-o kerberos.lo \
				-c kerberos.c || die "compiling pw-kerberos failed"
			einfo "Linking contrib-module: pw-kerberos"
			"${lt}" --mode=link --tag=CC \
				"${CC}" -module \
				${CFLAGS} \
				${LDFLAGS} \
				-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
				-o pw-kerberos.la \
				kerberos.lo || die "linking pw-kerberos failed"
			popd &>/dev/null || die
		fi

		if use pbkdf2; then
			pushd "${S}/contrib/slapd-modules/passwd/pbkdf2" &>/dev/null || die "pushd contrib/slapd-modules/passwd/pbkdf2"
			einfo "Compiling contrib-module: pw-pbkdf2"
			"${lt}" --mode=compile --tag=CC \
				"${CC}" \
				-I"${BUILD_DIR}"/include \
				-I../../../../include \
				${CFLAGS} \
				-o pbkdf2.lo \
				-c pw-pbkdf2.c || die "compiling pw-pbkdf2 failed"
			einfo "Linking contrib-module: pw-pbkdf2"
			"${lt}" --mode=link --tag=CC \
				"${CC}" -module \
				${CFLAGS} \
				${LDFLAGS} \
				-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
				-o pw-pbkdf2.la \
				pbkdf2.lo || die "linking pw-pbkdf2 failed"
			popd &>/dev/null || die
		fi

		if use sha2 ; then
			pushd "${S}/contrib/slapd-modules/passwd/sha2" &>/dev/null || die "pushd contrib/slapd-modules/passwd/sha2"
			einfo "Compiling contrib-module: pw-sha2"
			"${lt}" --mode=compile --tag=CC \
				"${CC}" \
				-I"${BUILD_DIR}"/include \
				-I../../../../include \
				${CFLAGS} \
				-o sha2.lo \
				-c sha2.c || die "compiling pw-sha2 failed"
			"${lt}" --mode=compile --tag=CC \
				"${CC}" \
				-I"${BUILD_DIR}"/include \
				-I../../../../include \
				${CFLAGS} \
				-o slapd-sha2.lo \
				-c slapd-sha2.c || die "compiling pw-sha2 failed"
			einfo "Linking contrib-module: pw-sha2"
			"${lt}" --mode=link --tag=CC \
				"${CC}" -module \
				${CFLAGS} \
				${LDFLAGS} \
				-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
				-o pw-sha2.la \
				sha2.lo slapd-sha2.lo || die "linking pw-sha2 failed"
			popd &>/dev/null || die
		fi

		# We could build pw-radius if GNURadius would install radlib.h
		pushd "${S}/contrib/slapd-modules/passwd" &>/dev/null || die "pushd contrib/slapd-modules/passwd"
		einfo "Compiling contrib-module: pw-netscape"
		"${lt}" --mode=compile --tag=CC \
			"${CC}" \
			-I"${BUILD_DIR}"/include \
			-I../../../include \
			${CFLAGS} \
			-o netscape.lo \
			-c netscape.c || die "compiling pw-netscape failed"
		einfo "Linking contrib-module: pw-netscape"
		"${lt}" --mode=link --tag=CC \
			"${CC}" -module \
			${CFLAGS} \
			${LDFLAGS} \
			-rpath "${EPREFIX}"/usr/$(get_libdir)/openldap/openldap \
			-o pw-netscape.la \
			netscape.lo || die "linking pw-netscape failed"

		#build_contrib_module "acl" "posixgroup.c" "posixGroup" # example code only
		#build_contrib_module "acl" "gssacl.c" "gss" # example code only, also needs kerberos
		build_contrib_module "addpartial" "addpartial-overlay.c" "addpartial-overlay"
		build_contrib_module "allop" "allop.c" "overlay-allop"
		build_contrib_module "allowed" "allowed.c" "allowed"
		build_contrib_module "autogroup" "autogroup.c" "autogroup"
		build_contrib_module "cloak" "cloak.c" "cloak"
		# comp_match: really complex, adds new external deps, questionable demand
		# build_contrib_module "comp_match" "comp_match.c" "comp_match"
		build_contrib_module "denyop" "denyop.c" "denyop-overlay"
		build_contrib_module "dsaschema" "dsaschema.c" "dsaschema-plugin"
		build_contrib_module "dupent" "dupent.c" "dupent"
		build_contrib_module "lastbind" "lastbind.c" "lastbind"
		# lastmod may not play well with other overlays
		build_contrib_module "lastmod" "lastmod.c" "lastmod"
		build_contrib_module "noopsrch" "noopsrch.c" "noopsrch"
		#build_contrib_module "nops" "nops.c" "nops-overlay" https://bugs.gentoo.org/641576
		#build_contrib_module "nssov" "nssov.c" "nssov-overlay" RESO:LATER
		build_contrib_module "trace" "trace.c" "trace"
		popd &>/dev/null || die
		# build slapi-plugins
		pushd "${S}/contrib/slapi-plugins/addrdnvalues" &>/dev/null || die "pushd contrib/slapi-plugins/addrdnvalues"
		einfo "Building contrib-module: addrdnvalues plugin"
		"${CC}" -shared \
			-I"${BUILD_DIR}"/include \
			-I../../../include \
			${CFLAGS} \
			-fPIC \
			${LDFLAGS} \
			-o libaddrdnvalues-plugin.so \
			addrdnvalues.c || die "Building libaddrdnvalues-plugin.so failed"
		popd &>/dev/null || die
	fi
}

multilib_src_test() {
	if multilib_is_native_abi; then
		cd tests || die
		emake tests
	fi
}

multilib_src_install() {
	local lt="${BUILD_DIR}/libtool"
	emake DESTDIR="${D}" SHELL="${EPREFIX}"/bin/sh install

	if ! use minimal && multilib_is_native_abi; then
		# openldap modules go here
		# TODO: write some code to populate slapd.conf with moduleload statements
		keepdir /usr/$(get_libdir)/openldap/openldap/

		# initial data storage dir
		keepdir /var/lib/openldap-data
		use prefix || fowners ldap:ldap /var/lib/openldap-data
		fperms 0700 /var/lib/openldap-data

		echo "OLDPF='${PF}'" > "${ED}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"
		echo "# do NOT delete this. it is used"	>> "${ED}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"
		echo "# to track versions for upgrading." >> "${ED}${OPENLDAP_DEFAULTDIR_VERSIONTAG}/${OPENLDAP_VERSIONTAG}"

		# use our config
		rm "${ED}"/etc/openldap/slapd.conf
		insinto /etc/openldap
		newins "${FILESDIR}"/${PN}-2.4.40-slapd-conf slapd.conf
		configfile="${ED}"/etc/openldap/slapd.conf

		# populate with built backends
		einfo "populate config with built backends"
		for x in "${ED}"/usr/$(get_libdir)/openldap/openldap/back_*.so; do
			einfo "Adding $(basename ${x})"
			sed -e "/###INSERTDYNAMICMODULESHERE###$/a# moduleload\t$(basename ${x})" -i "${configfile}" || die
		done
		sed -e "s:###INSERTDYNAMICMODULESHERE###$:# modulepath\t${EPREFIX}/usr/$(get_libdir)/openldap/openldap:" \
			-i "${configfile}"
		use prefix || fowners root:ldap /etc/openldap/slapd.conf
		fperms 0640 /etc/openldap/slapd.conf
		cp "${configfile}" "${configfile}".default || die

		# install our own init scripts and systemd unit files
		einfo "Install init scripts"
		sed -e "s,/usr/lib/,/usr/$(get_libdir)/," "${FILESDIR}"/slapd-initd-2.4.40-r2 > "${T}"/slapd || die
		doinitd "${T}"/slapd
		newconfd "${FILESDIR}"/slapd-confd-2.4.28-r1 slapd

		einfo "Install systemd service"
		sed -e "s,/usr/lib/,/usr/$(get_libdir)/," "${FILESDIR}"/slapd.service > "${T}"/slapd.service || die
		systemd_dounit "${T}"/slapd.service
		systemd_install_serviced "${FILESDIR}"/slapd.service.conf
		newtmpfiles "${FILESDIR}"/slapd.tmpfilesd slapd.conf

		# If built without SLP, we don't need to be before avahi
			sed -i \
				-e '/before/{s/avahi-daemon//g}' \
				"${ED}"/etc/init.d/slapd \
				|| die

		if use cxx ; then
			einfo "Install the ldapc++ library"
			cd "${BUILD_DIR}/contrib/ldapc++" || die
			emake DESTDIR="${D}" libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap" install
			cd "${S}"/contrib/ldapc++ || die
			newdoc README ldapc++-README
		fi

		if use smbkrb5passwd ; then
			einfo "Install the smbk5pwd module"
			cd "${S}/contrib/slapd-modules/smbk5pwd" || die
			emake DESTDIR="${D}" \
				LDAP_BUILD="${BUILD_DIR}" \
				libexecdir="${EPREFIX}/usr/$(get_libdir)/openldap" install
			newdoc README smbk5pwd-README
		fi

		if use overlays ; then
			einfo "Install the samba4 module"
			cd "${S}/contrib/slapd-modules/samba4" || die
			emake DESTDIR="${D}" \
				LDAP_BUILD="${BUILD_DIR}" \
				libexecdir="/usr/$(get_libdir)/openldap" install
			newdoc README samba4-README
		fi

		einfo "Installing contrib modules"
		cd "${S}/contrib/slapd-modules" || die
		for l in */*.la */*/*.la; do
			[[ -e ${l} ]] || continue
			"${lt}" --mode=install cp ${l} \
				"${ED}"/usr/$(get_libdir)/openldap/openldap || \
				die "installing ${l} failed"
		done

		dodoc "${FILESDIR}"/DB_CONFIG.fast.example
		docinto contrib
		doman */*.5
		#newdoc acl/README*
		newdoc addpartial/README addpartial-README
		newdoc allop/README allop-README
		newdoc allowed/README allowed-README
		newdoc autogroup/README autogroup-README
		newdoc dsaschema/README dsaschema-README
		newdoc passwd/README passwd-README
		cd "${S}/contrib/slapi-plugins" || die
		insinto /usr/$(get_libdir)/openldap/openldap
		doins */*.so
		docinto contrib
		newdoc addrdnvalues/README addrdnvalues-README

		insinto /etc/openldap/schema
		newins "${DISTDIR}"/${BIS_P} ${BIS_PN}

		docinto back-sock ; dodoc "${S}"/servers/slapd/back-sock/searchexample*
		docinto back-shell ; dodoc "${S}"/servers/slapd/back-shell/searchexample*
		docinto back-perl ; dodoc "${S}"/servers/slapd/back-perl/SampleLDAP.pm

		dosbin "${S}"/contrib/slapd-tools/statslog
		newdoc "${S}"/contrib/slapd-tools/README README.statslog
	fi

	if ! use static-libs ; then
		find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
	fi
}

multilib_src_install_all() {
	dodoc ANNOUNCEMENT CHANGES COPYRIGHT README
	docinto rfc ; dodoc doc/rfc/*.txt
}

pkg_preinst() {
	# keep old libs if any
	preserve_old_lib /usr/$(get_libdir)/{liblber,libldap_r,liblber}-2.3$(get_libname 0)
	# bug 440470, only display the getting started help there was no openldap before,
	# or we are going to a non-minimal build
	! has_version net-nds/openldap || has_version 'net-nds/openldap[minimal]'
	OPENLDAP_PRINT_MESSAGES=$((! $?))
}

pkg_postinst() {
	if ! use minimal ; then
		tmpfiles_process slapd.conf

		# You cannot build SSL certificates during src_install that will make
		# binary packages containing your SSL key, which is both a security risk
		# and a misconfiguration if multiple machines use the same key and cert.
		if use ssl; then
			install_cert /etc/openldap/ssl/ldap
			use prefix || chown ldap:ldap "${EROOT}"/etc/openldap/ssl/ldap.*
			ewarn "Self-signed SSL certificates are treated harshly by OpenLDAP 2.[12]"
			ewarn "Self-signed SSL certificates are treated harshly by OpenLDAP 2.[12]"
			ewarn "add 'TLS_REQCERT allow' if you want to use them."
		fi

		if use prefix; then
			# Warn about prefix issues with slapd
			eerror "slapd might NOT be usable on Prefix systems as it requires root privileges"
			eerror "to start up, and requires that certain files directories be owned by"
			eerror "ldap:ldap.  As Prefix does not support changing ownership of files and"
			eerror "directories, you will have to manually fix this yourself."
		fi

		# These lines force the permissions of various content to be correct
		if [[ -d "${EROOT}"/var/run/openldap ]]; then
			use prefix || { chown ldap:ldap "${EROOT}"/var/run/openldap || die; }
			chmod 0755 "${EROOT}"/var/run/openldap || die
		fi
		use prefix || chown root:ldap "${EROOT}"/etc/openldap/slapd.conf{,.default}
		chmod 0640 "${EROOT}"/etc/openldap/slapd.conf{,.default} || die
		use prefix || chown ldap:ldap "${EROOT}"/var/lib/openldap-data
	fi

	if has_version 'net-nds/openldap[-minimal]' && ((${OPENLDAP_PRINT_MESSAGES})); then
		elog "Getting started using OpenLDAP? There is some documentation available:"
		elog "Gentoo Guide to OpenLDAP Authentication"
		elog "(https://wiki.gentoo.org/wiki/Centralized_authentication_using_OpenLDAP)"
		elog "---"
		elog "An example file for tuning BDB backends with openldap is"
		elog "DB_CONFIG.fast.example in /usr/share/doc/${PF}/"
	fi

	preserve_old_lib_notify /usr/$(get_libdir)/{liblber,libldap,libldap_r}-2.3$(get_libname 0)
}
