# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql-server/postgresql-server-9.3.2.ebuild,v 1.9 2013/12/22 13:40:36 ago Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_{6,7},3_{2,3}} )
WANT_AUTOMAKE="none"

inherit autotools eutils flag-o-matic multilib pam prefix python-single-r1 systemd user versionator

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos ~x86-solaris"

SLOT="$(get_version_component_range 1-2)"
S="${WORKDIR}/postgresql-9.4beta1"
SRC_URI="http://ftp.postgresql.org/pub/source/v9.4beta1/postgresql-9.4beta1.tar.bz2
		 http://dev.gentoo.org/~titanofold/postgresql-initscript-2.5.tbz2
		 http://dev.gentoo.org/~titanofold/postgresql-patches-9.3-r1.tbz2
		 "

LICENSE="POSTGRESQL GPL-2"
DESCRIPTION="PostgreSQL server"
HOMEPAGE="http://www.postgresql.org/"

LINGUAS="af cs de en es fa fr hr hu it ko nb pl pt_BR ro ru sk sl sv tr zh_CN zh_TW"
IUSE="doc kerberos kernel_linux nls pam perl -pg_legacytimestamp python selinux tcl test uuid xml"

for lingua in ${LINGUAS}; do
	IUSE+=" linguas_${lingua}"
done

wanted_languages() {
	local enable_langs

	for lingua in ${LINGUAS} ; do
		use linguas_${lingua} && enable_langs+="${lingua} "
	done

	echo -n ${enable_langs}
}

RDEPEND="
~dev-db/postgresql-base-${PV}[kerberos?,pam?,pg_legacytimestamp=,python=,nls=]
perl? ( >=dev-lang/perl-5.8 )
python? ( ${PYTHON_DEPS} )
selinux? ( sec-policy/selinux-postgresql )
tcl? ( >=dev-lang/tcl-8 )
uuid? ( dev-libs/ossp-uuid )
xml? ( dev-libs/libxml2 dev-libs/libxslt )
"

DEPEND="${RDEPEND}
sys-devel/flex
xml? ( virtual/pkgconfig )
"

PDEPEND="doc? ( ~dev-db/postgresql-docs-${PV} )"

pkg_setup() {
	enewgroup postgres 70
	enewuser postgres 70 /bin/bash /var/lib/postgresql postgres

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -e "s/9.3/9.4/" -i ${WORKDIR}/autoconf.patch
	sed -e "s/configure.in\t/postgresql-9.4beta1\/configure.in\t/" -i ${WORKDIR}/autoconf.patch
	sed -e "s/2.63/2.69/" -i ${WORKDIR}/autoconf.patch
	sed -e "s/2.63/2.69/" -i ${WORKDIR}/autoconf.patch
	sed -e "s/2013/2014/" -i ${WORKDIR}/autoconf.patch
	epatch "${WORKDIR}/autoconf.patch" \
		 "${WORKDIR}/bool.patch" \
		 "${WORKDIR}/server.patch" \
		 "${WORKDIR}/run-dir.patch"
	eprefixify src/include/pg_config_manual.h

	if use pam ; then
		sed -e "s/\(#define PGSQL_PAM_SERVICE \"postgresql\)/\1-${SLOT}/" \
			-i src/backend/libpq/auth.c \
			|| die 'PGSQL_PAM_SERVICE rename failed.'
	fi

	if use perl ; then
		sed -e "s:\$(DESTDIR)\$(plperl_installdir):\$(plperl_installdir):" \
			-i "${S}/src/pl/plperl/GNUmakefile" || die 'sed plperl failed'
	fi

	if use test ; then
		#epatch "${WORKDIR}/regress.patch"
		sed -e "s|@SOCKETDIR@|${T}|g" -i src/test/regress/pg_regress{,_main}.c
	else
		echo "all install:" > "${S}/src/test/regress/GNUmakefile"
	fi

	sed -e "s|@SLOT@|${SLOT}|g" \
		-i "${WORKDIR}"/postgresql.{init,confd,service} || \
		die "SLOT sed failed"

	eautoconf
}

src_configure() {
	case ${CHOST} in
		*-darwin*|*-solaris*)
			use nls && append-libs intl
			;;
	esac

	local PO="${EPREFIX%/}"

	# eval is needed to get along with pg_config quotation of space-rich entities.
	eval econf "$(${PO}/usr/$(get_libdir)/postgresql-${SLOT}/bin/pg_config --configure)" \
		$(use_with perl) \
		$(use_with tcl) \
		$(use_with xml libxml) \
		$(use_with xml libxslt) \
		$(use_with uuid ossp-uuid) \
		--with-system-tzdata="${PO}/usr/share/zoneinfo" \
		--with-includes="${PO}/usr/include/postgresql-${SLOT}/" \
		--with-libraries="${PO}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)" \
		"$(use_enable nls nls "$(wanted_languages)")"
}

src_compile() {
	local bd
	for bd in . contrib $(use xml && echo contrib/xml2); do
		PATH="${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin:${PATH}" \
			emake -C $bd || die "emake in $bd failed"
	done
}

src_install() {
	local bd
	for bd in . contrib $(use xml && echo contrib/xml2) ; do
		PATH="${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin:${PATH}" \
			emake install -C $bd DESTDIR="${D}" || die "emake install in $bd failed"
	done

	# Avoid file collision with -base.
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/libpgcommon.a"
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/adminpack.so"
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/autoinc.so"
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/btree_gin.so"
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/dict_snowball.so"
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/pageinspect.so"
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/pgstattuple.so"
	rm "${ED}/usr/$(get_libdir)/postgresql-${SLOT}/$(get_libdir)/utf8_and_johab.so"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/initdb"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_archivecleanup"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_basebackup"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_controldata"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_ctl"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_receivexlog"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_recvlogical"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_resetxlog"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_standby"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_test_fsync"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_test_timing"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_upgrade"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/pg_xlogdump"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/postgres"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/euc_kr_and_mic.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/auth_delay.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_euc_kr.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/plpgsql.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/test_parser.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/hstore.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/seg.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/latin_and_mic.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/moddatetime.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/isn.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/ascii_and_mic.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/cube.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_big5.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/euc_tw_and_big5.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/test_shm_mq.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/libpqwalreceiver.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_uhc.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/file_fdw.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_sjis.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_sjis2004.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/refint.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_iso8859.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_cyrillic.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/chkpass.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pg_upgrade_support.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/auto_explain.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_win.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pgrowlocks.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/ltree.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_gbk.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/citext.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pg_prewarm.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/tsearch2.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_ascii.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/btree_gist.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pg_freespacemap.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_iso8859_1.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/unaccent.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pgcrypto.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/tcn.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/earthdistance.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/tablefunc.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/euc_jp_and_sjis.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_euc_cn.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/sslinfo.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/passwordcheck.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_euc_jp.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_gb18030.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pg_stat_statements.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_euc2004.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pg_trgm.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/cyrillic_and_mic.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/dummy_seclabel.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/lo.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/timetravel.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/pg_buffercache.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/postgres_fdw.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/worker_spi.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/euc_cn_and_mic.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/dict_xsyn.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/latin2_and_win1250.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/dblink.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/euc2004_sjis2004.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/fuzzystrmatch.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/insert_username.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/dict_int.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/test_decoding.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/utf8_and_euc_tw.so"
	rm "${ED}/usr/lib64/postgresql-9.4/lib64/_int.so"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pl/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pl/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pl/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pl/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pl/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pl/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/de/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/de/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/de/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/de/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/de/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/de/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ru/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ru/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ru/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ru/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ru/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ru/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ja/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ja/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ja/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ja/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ja/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ja/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/es/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/es/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/es/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/es/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/es/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/es/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/fr/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/fr/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/fr/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/fr/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/fr/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/fr/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/cs/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/cs/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/cs/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/cs/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/cs/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/cs/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/ro/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_CN/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_CN/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_CN/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_CN/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_CN/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_CN/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/sv/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_TW/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/zh_TW/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pt_BR/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pt_BR/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pt_BR/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pt_BR/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pt_BR/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/pt_BR/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/it/LC_MESSAGES/pg_controldata-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/it/LC_MESSAGES/pg_resetxlog-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/it/LC_MESSAGES/initdb-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/it/LC_MESSAGES/pg_basebackup-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/it/LC_MESSAGES/pg_ctl-9.4.mo"
	rm "${ED}/usr/lib64/postgresql-9.4/share/locale/it/LC_MESSAGES/plpgsql-9.4.mo"
	rm "${ED}/usr/include/postgresql-9.4/server/plpgsql.h"
	rm "${ED}/usr/share/postgresql-9.4/postgres.shdescription"
	rm "${ED}/usr/share/postgresql-9.4/postgres.bki"
	rm "${ED}/usr/share/postgresql-9.4/snowball_create.sql"
	rm "${ED}/usr/share/postgresql-9.4/pg_ident.conf.sample"
	rm "${ED}/usr/share/postgresql-9.4/postgresql.conf.sample"
	rm "${ED}/usr/share/postgresql-9.4/information_schema.sql"
	rm "${ED}/usr/share/postgresql-9.4/recovery.conf.sample"
	rm "${ED}/usr/share/postgresql-9.4/sql_features.txt"
	rm "${ED}/usr/share/postgresql-9.4/postgres.description"
	rm "${ED}/usr/share/postgresql-9.4/conversion_create.sql"
	rm "${ED}/usr/share/postgresql-9.4/system_views.sql"
	rm "${ED}/usr/share/postgresql-9.4/pg_hba.conf.sample"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/India"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Indian.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Europe.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Pacific.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Australia.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Default"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Etc.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Australia"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/America.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Asia.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Africa.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Antarctica.txt"
	rm "${ED}/usr/share/postgresql-9.4/timezonesets/Atlantic.txt"
	rm "${ED}/usr/share/postgresql-9.4/extension/autoinc--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/hstore--1.1--1.2.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/lo--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/tcn.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/autoinc--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgstattuple--1.2.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/unaccent--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgstattuple--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/earthdistance--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/moddatetime--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/test_parser--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_trgm--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/intagg--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_stat_statements.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/unaccent--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/insert_username.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pageinspect--1.1--1.2.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/hstore--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pageinspect--1.2.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pageinspect--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/file_fdw--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/citext--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgrowlocks.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/sslinfo.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgcrypto.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/dict_int--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/btree_gist.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgstattuple.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/btree_gin--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/adminpack--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/refint--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/ltree--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_freespacemap.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/chkpass.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/ltree.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgcrypto--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/test_parser.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/plpgsql--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/test_shm_mq--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/dict_int.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/refint.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/isn.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/cube--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgrowlocks--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/plpgsql.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/citext.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_stat_statements--1.2.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_prewarm.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/citext--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/refint--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/timetravel--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/tablefunc--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/fuzzystrmatch--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pageinspect.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/earthdistance--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/dblink--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/timetravel--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/moddatetime.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_prewarm--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/tsearch2--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_freespacemap--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_stat_statements--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_buffercache.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/dict_int--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgstattuple--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/intarray.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/tsearch2.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/insert_username--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/hstore.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgrowlocks--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/dblink--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/moddatetime--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_buffercache--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/fuzzystrmatch--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/seg--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/isn--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/file_fdw.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/hstore--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/test_shm_mq.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/test_parser--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/intagg.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/tcn--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_trgm--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/lo.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_stat_statements--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/unaccent.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/hstore--1.3.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/earthdistance.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/btree_gist--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/btree_gin.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/fuzzystrmatch.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/dict_xsyn.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/cube.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/dict_xsyn--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/insert_username--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/intarray--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/timetravel.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_freespacemap--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/btree_gist--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/chkpass--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/adminpack.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/autoinc.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/intarray--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/hstore--1.2--1.3.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/postgres_fdw--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/tablefunc--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/dblink--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/seg.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/plpgsql--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgstattuple--1.1--1.2.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/isn--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_trgm.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/tsearch2--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/sslinfo--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_buffercache--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/worker_spi.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgcrypto--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgrowlocks--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/postgres_fdw.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/ltree--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/dict_xsyn--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/chkpass--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/sslinfo--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/worker_spi--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/cube--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/tablefunc.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_stat_statements--1.1--1.2.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/lo--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pageinspect--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/seg--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/btree_gin--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pgcrypto--1.0--1.1.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/dblink.control"
	rm "${ED}/usr/share/postgresql-9.4/extension/intagg--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/extension/pg_trgm--unpackaged--1.0.sql"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/german.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/russian.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/french.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/synonym_sample.syn"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/english.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/dutch.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/hunspell_sample.affix"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/unaccent.rules"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/spanish.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/turkish.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/xsyn_sample.rules"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/danish.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/italian.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/portuguese.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/hungarian.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/ispell_sample.dict"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/finnish.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/norwegian.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/swedish.stop"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/thesaurus_sample.ths"
	rm "${ED}/usr/share/postgresql-9.4/tsearch_data/ispell_sample.affix"
	rm "${ED}/usr/share/doc/postgresql-9.4/extension/insert_username.example.bz2"
	rm "${ED}/usr/share/doc/postgresql-9.4/extension/refint.example.bz2"
	rm "${ED}/usr/share/doc/postgresql-9.4/extension/autoinc.example.bz2"
	rm "${ED}/usr/share/doc/postgresql-9.4/extension/timetravel.example.bz2"
	rm "${ED}/usr/share/doc/postgresql-9.4/extension/moddatetime.example.bz2"
	rm "${ED}/usr/lib64/postgresql-9.4/bin/postmaster"
	rm -rf "${ED}/usr/share/doc/postgresql-9.4/extension/"
	dodir /etc/eselect/postgresql/slots/${SLOT}
	echo "postgres_ebuilds=\"\${postgres_ebuilds} ${PF}\"" > \
		"${ED}/etc/eselect/postgresql/slots/${SLOT}/server"

	newconfd "${WORKDIR}/postgresql.confd" postgresql-${SLOT}
	newinitd "${WORKDIR}/postgresql.init" postgresql-${SLOT}

	systemd_newunit "${WORKDIR}"/postgresql.service postgresql-${SLOT}.service
	systemd_newtmpfilesd "${WORKDIR}"/postgresql.tmpfilesd postgresql-${SLOT}.conf

	use pam && pamd_mimic system-auth postgresql-${SLOT} auth account session

	if use prefix ; then
		keepdir /run/postgresql
		fperms 0775 /run/postgresql
	fi
}

pkg_postinst() {
	postgresql-config update

	elog "Gentoo specific documentation:"
	elog "http://www.gentoo.org/doc/en/postgres-howto.xml"
	elog
	elog "Official documentation:"
	elog "http://www.postgresql.org/docs/${SLOT}/static/index.html"
	elog
	elog "The default location of the Unix-domain socket is:"
	elog "    ${EROOT%/}/run/postgresql/"
	elog
	elog "Before initializing the database, you may want to edit PG_INITDB_OPTS"
	elog "so that it contains your preferred locale in:"
	elog "    ${EROOT%/}/etc/conf.d/postgresql-${SLOT}"
	elog
	elog "Then, execute the following command to setup the initial database"
	elog "environment:"
	elog "    emerge --config =${CATEGORY}/${PF}"
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		ewarn "Have you dumped and/or migrated the ${SLOT} database cluster?"
		ewarn "\thttp://www.gentoo.org/doc/en/postgres-howto.xml#doc_chap5"

		ebegin "Resuming removal in 10 seconds (Control-C to cancel)"
		sleep 10
		eend 0
	fi
}

pkg_postrm() {
	postgresql-config update
}

pkg_config() {
	[[ -f "${EROOT%/}/etc/conf.d/postgresql-${SLOT}" ]] && source "${EROOT%/}/etc/conf.d/postgresql-${SLOT}"
	[[ -z "${PGDATA}" ]] && PGDATA="${EROOT%/}/etc/postgresql-${SLOT}/"
	[[ -z "${DATA_DIR}" ]] && DATA_DIR="${EROOT%/}/var/lib/postgresql/${SLOT}/data"

	# environment.bz2 may not contain the same locale as the current system
	# locale. Unset and source from the current system locale.
	if [ -f "${EROOT%/}/etc/env.d/02locale" ]; then
		unset LANG
		unset LC_CTYPE
		unset LC_NUMERIC
		unset LC_TIME
		unset LC_COLLATE
		unset LC_MONETARY
		unset LC_MESSAGES
		unset LC_ALL
		source "${EROOT%/}/etc/env.d/02locale"
		[ -n "${LANG}" ] && export LANG
		[ -n "${LC_CTYPE}" ] && export LC_CTYPE
		[ -n "${LC_NUMERIC}" ] && export LC_NUMERIC
		[ -n "${LC_TIME}" ] && export LC_TIME
		[ -n "${LC_COLLATE}" ] && export LC_COLLATE
		[ -n "${LC_MONETARY}" ] && export LC_MONETARY
		[ -n "${LC_MESSAGES}" ] && export LC_MESSAGES
		[ -n "${LC_ALL}" ] && export LC_ALL
	fi

	einfo "You can modify the paths and options passed to initdb by editing:"
	einfo "    ${EROOT%/}/etc/conf.d/postgresql-${SLOT}"
	einfo
	einfo "Information on options that can be passed to initdb are found at:"
	einfo "    http://www.postgresql.org/docs/${SLOT}/static/creating-cluster.html"
	einfo "    http://www.postgresql.org/docs/${SLOT}/static/app-initdb.html"
	einfo
	einfo "PG_INITDB_OPTS is currently set to:"
	if [[ -z "${PG_INITDB_OPTS}" ]] ; then
		einfo "    (none)"
	else
		einfo "    ${PG_INITDB_OPTS}"
	fi
	einfo
	einfo "Configuration files will be installed to:"
	einfo "    ${PGDATA}"
	einfo
	einfo "The database cluster will be created in:"
	einfo "    ${DATA_DIR}"
	einfo
	while [ "$correct" != "true" ] ; do
		einfo "Are you ready to continue? (y/n)"
		read answer
		if [[ $answer =~ ^[Yy]([Ee][Ss])?$ ]] ; then
			correct="true"
		elif [[ $answer =~ ^[Nn]([Oo])?$ ]] ; then
			die "Aborting initialization."
		else
			echo "Answer not recognized"
		fi
	done

	if [ -n "$(ls -A ${DATA_DIR} 2> /dev/null)" ] ; then
		eerror "The given directory, '${DATA_DIR}', is not empty."
		eerror "Modify DATA_DIR to point to an empty directory."
		die "${DATA_DIR} is not empty."
	fi

	[ -z "${PG_MAX_CONNECTIONS}" ] && PG_MAX_CONNECTIONS="128"
	einfo "Checking system parameters..."

	if ! use kernel_linux ; then
		einfo "Skipped."
		einfo "  Tests not supported on this OS (yet)"
	else
		if [ -z ${SKIP_SYSTEM_TESTS} ] ; then
			einfo "Checking whether your system supports at least ${PG_MAX_CONNECTIONS} connections..."

			local SEMMSL=$(sysctl -n kernel.sem | cut -f1)
			local SEMMNS=$(sysctl -n kernel.sem | cut -f2)
			local SEMMNI=$(sysctl -n kernel.sem | cut -f4)
			local SHMMAX=$(sysctl -n kernel.shmmax)

			local SEMMSL_MIN=17
			local SEMMNS_MIN=$(( ( ${PG_MAX_CONNECTIONS}/16 ) * 17 ))
			local SEMMNI_MIN=$(( ( ${PG_MAX_CONNECTIONS}+15 ) / 16 ))
			local SHMMAX_MIN=$(( 500000 + ( 30600 * ${PG_MAX_CONNECTIONS} ) ))

			for p in SEMMSL SEMMNS SEMMNI SHMMAX ; do
				if [ $(eval echo \$$p) -lt $(eval echo \$${p}_MIN) ] ; then
					eerror "The value for ${p} $(eval echo \$$p) is below the recommended value $(eval echo \$${p}_MIN)"
					eerror "You have now several options:"
					eerror "    - Change the mentioned system parameter"
					eerror "    - Lower the number of max.connections by setting PG_MAX_CONNECTIONS to a"
					eerror "      value lower than ${PG_MAX_CONNECTIONS}"
					eerror "    - Set SKIP_SYSTEM_TESTS in case you want to ignore this test completely"
					eerror "More information can be found here:"
					eerror "    http://www.postgresql.org/docs/${SLOT}/static/kernel-resources.html"
					die "System test failed."
				fi
			done
			einfo "Passed."
		else
			ewarn "SKIP_SYSTEM_TESTS set, so skipping."
		fi
	fi

	einfo "Creating the data directory ..."
	if [[ ${EUID} == 0 ]] ; then
		mkdir -p "${DATA_DIR}"
		chown -Rf postgres:postgres "${DATA_DIR}"
		chmod 0700 "${DATA_DIR}"
	fi

	einfo "Initializing the database ..."

	if [[ ${EUID} == 0 ]] ; then
		su postgres -c "${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin/initdb -D \"${DATA_DIR}\" ${PG_INITDB_OPTS}"
	else
		"${EROOT%/}"/usr/$(get_libdir)/postgresql-${SLOT}/bin/initdb -U postgres -D "${DATA_DIR}" ${PG_INITDB_OPTS}
	fi

	mv "${DATA_DIR%/}"/*.conf "${PGDATA}"

	einfo "The autovacuum function, which was in contrib, has been moved to the main"
	einfo "PostgreSQL functions starting with 8.1, and starting with 8.4 is now enabled"
	einfo "by default. You can disable it in the cluster's:"
	einfo "    ${PGDATA%/}/postgresql.conf"
	einfo
	einfo "The PostgreSQL server, by default, will log events to:"
	einfo "    ${DATA_DIR%/}/postmaster.log"
	einfo
	if use prefix ; then
		einfo "The location of the configuration files have moved to:"
		einfo "    ${PGDATA}"
		einfo "To start the server:"
		einfo "    pg_ctl start -D ${DATA_DIR} -o '-D ${PGDATA} --data-directory=${DATA_DIR}'"
		einfo "To stop:"
		einfo "    pg_ctl stop -D ${DATA_DIR}"
		einfo
		einfo "Or move the configuration files back:"
		einfo "mv ${PGDATA}*.conf ${DATA_DIR}"
	else
		einfo "You should use the '${EROOT%/}/etc/init.d/postgresql-${SLOT}' script to run PostgreSQL"
		einfo "instead of 'pg_ctl'."
	fi
}

src_test() {
	einfo ">>> Test phase [check]: ${CATEGORY}/${PF}"

	if [ ${UID} -ne 0 ] ; then
		emake check

		einfo "If you think other tests besides the regression tests are necessary, please"
		einfo "submit a bug including a patch for this ebuild to enable them."
	else
		ewarn "Tests cannot be run as root. Skipping."
		ewarn "HINT: FEATURES=\"userpriv\""
	fi
}
