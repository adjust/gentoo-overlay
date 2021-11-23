# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# needed to make webapp-config dep optional
WEBAPP_OPTIONAL="yes"
inherit webapp java-pkg-opt-2 systemd tmpfiles toolchain-funcs go-module user-info

EGO_SUM=(
	"github.com/BurntSushi/locker v0.0.0-20171006230638-a6e239ea1c69"
	"github.com/BurntSushi/locker v0.0.0-20171006230638-a6e239ea1c69/go.mod"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/cakturk/go-netstat v0.0.0-20200220111822-e5b49efee7a5"
	"github.com/cakturk/go-netstat v0.0.0-20200220111822-e5b49efee7a5/go.mod"
	"github.com/chromedp/cdproto v0.0.0-20210104223854-2cc87dae3ee3"
	"github.com/chromedp/cdproto v0.0.0-20210104223854-2cc87dae3ee3/go.mod"
	"github.com/chromedp/chromedp v0.6.0"
	"github.com/chromedp/chromedp v0.6.0/go.mod"
	"github.com/chromedp/sysutil v1.0.0"
	"github.com/chromedp/sysutil v1.0.0/go.mod"
	"github.com/cockroachdb/apd v1.1.0"
	"github.com/cockroachdb/apd v1.1.0/go.mod"
	"github.com/coreos/go-systemd v0.0.0-20190321100706-95778dfbb74e/go.mod"
	"github.com/coreos/go-systemd v0.0.0-20190719114852-fd7a80b32e1f/go.mod"
	"github.com/creack/pty v1.1.7/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dustin/gomemcached v0.0.0-20160817010731-a2284a01c143"
	"github.com/dustin/gomemcached v0.0.0-20160817010731-a2284a01c143/go.mod"
	"github.com/eclipse/paho.mqtt.golang v1.2.0"
	"github.com/eclipse/paho.mqtt.golang v1.2.0/go.mod"
	"github.com/fsnotify/fsnotify v1.4.9"
	"github.com/fsnotify/fsnotify v1.4.9/go.mod"
	"github.com/go-ldap/ldap v3.0.3+incompatible"
	"github.com/go-ldap/ldap v3.0.3+incompatible/go.mod"
	"github.com/go-logfmt/logfmt v0.5.0"
	"github.com/go-logfmt/logfmt v0.5.0/go.mod"
	"github.com/go-ole/go-ole v1.2.4"
	"github.com/go-ole/go-ole v1.2.4/go.mod"
	"github.com/go-sql-driver/mysql v1.5.0"
	"github.com/go-sql-driver/mysql v1.5.0/go.mod"
	"github.com/go-stack/stack v1.8.0/go.mod"
	"github.com/goburrow/modbus v0.1.0"
	"github.com/goburrow/modbus v0.1.0/go.mod"
	"github.com/goburrow/serial v0.1.0"
	"github.com/goburrow/serial v0.1.0/go.mod"
	"github.com/gobwas/httphead v0.1.0"
	"github.com/gobwas/httphead v0.1.0/go.mod"
	"github.com/gobwas/pool v0.2.1"
	"github.com/gobwas/pool v0.2.1/go.mod"
	"github.com/gobwas/ws v1.0.4"
	"github.com/gobwas/ws v1.0.4/go.mod"
	"github.com/godbus/dbus v4.1.0+incompatible"
	"github.com/godbus/dbus v4.1.0+incompatible/go.mod"
	"github.com/godror/godror v0.20.1"
	"github.com/godror/godror v0.20.1/go.mod"
	"github.com/gofrs/uuid v3.2.0+incompatible"
	"github.com/gofrs/uuid v3.2.0+incompatible/go.mod"
	"github.com/google/go-cmp v0.4.0"
	"github.com/google/go-cmp v0.4.0/go.mod"
	"github.com/google/renameio v0.1.0/go.mod"
	"github.com/jackc/chunkreader v1.0.0"
	"github.com/jackc/chunkreader v1.0.0/go.mod"
	"github.com/jackc/chunkreader/v2 v2.0.0/go.mod"
	"github.com/jackc/chunkreader/v2 v2.0.1"
	"github.com/jackc/chunkreader/v2 v2.0.1/go.mod"
	"github.com/jackc/pgconn v0.0.0-20190420214824-7e0022ef6ba3/go.mod"
	"github.com/jackc/pgconn v0.0.0-20190824142844-760dd75542eb/go.mod"
	"github.com/jackc/pgconn v0.0.0-20190831204454-2fabfa3c18b7/go.mod"
	"github.com/jackc/pgconn v1.4.0/go.mod"
	"github.com/jackc/pgconn v1.5.0/go.mod"
	"github.com/jackc/pgconn v1.5.1-0.20200601181101-fa742c524853/go.mod"
	"github.com/jackc/pgconn v1.6.5-0.20200905181414-0d4f029683fc"
	"github.com/jackc/pgconn v1.6.5-0.20200905181414-0d4f029683fc/go.mod"
	"github.com/jackc/pgio v1.0.0"
	"github.com/jackc/pgio v1.0.0/go.mod"
	"github.com/jackc/pgmock v0.0.0-20190831213851-13a1b77aafa2"
	"github.com/jackc/pgmock v0.0.0-20190831213851-13a1b77aafa2/go.mod"
	"github.com/jackc/pgpassfile v1.0.0"
	"github.com/jackc/pgpassfile v1.0.0/go.mod"
	"github.com/jackc/pgproto3 v1.1.0"
	"github.com/jackc/pgproto3 v1.1.0/go.mod"
	"github.com/jackc/pgproto3/v2 v2.0.0-alpha1.0.20190420180111-c116219b62db/go.mod"
	"github.com/jackc/pgproto3/v2 v2.0.0-alpha1.0.20190609003834-432c2951c711/go.mod"
	"github.com/jackc/pgproto3/v2 v2.0.0-rc3/go.mod"
	"github.com/jackc/pgproto3/v2 v2.0.0-rc3.0.20190831210041-4c03ce451f29/go.mod"
	"github.com/jackc/pgproto3/v2 v2.0.1/go.mod"
	"github.com/jackc/pgproto3/v2 v2.0.4"
	"github.com/jackc/pgproto3/v2 v2.0.4/go.mod"
	"github.com/jackc/pgservicefile v0.0.0-20200307190119-3430c5407db8/go.mod"
	"github.com/jackc/pgservicefile v0.0.0-20200714003250-2b9c44734f2b"
	"github.com/jackc/pgservicefile v0.0.0-20200714003250-2b9c44734f2b/go.mod"
	"github.com/jackc/pgtype v0.0.0-20190421001408-4ed0de4755e0/go.mod"
	"github.com/jackc/pgtype v0.0.0-20190824184912-ab885b375b90/go.mod"
	"github.com/jackc/pgtype v0.0.0-20190828014616-a8802b16cc59/go.mod"
	"github.com/jackc/pgtype v1.2.0/go.mod"
	"github.com/jackc/pgtype v1.3.1-0.20200510190516-8cd94a14c75a/go.mod"
	"github.com/jackc/pgtype v1.3.1-0.20200606141011-f6355165a91c/go.mod"
	"github.com/jackc/pgtype v1.4.3-0.20200905161353-e7d2b057a716"
	"github.com/jackc/pgtype v1.4.3-0.20200905161353-e7d2b057a716/go.mod"
	"github.com/jackc/pgx/v4 v4.0.0-20190420224344-cc3461e65d96/go.mod"
	"github.com/jackc/pgx/v4 v4.0.0-20190421002000-1b8f0016e912/go.mod"
	"github.com/jackc/pgx/v4 v4.0.0-pre1.0.20190824185557-6972a5742186/go.mod"
	"github.com/jackc/pgx/v4 v4.5.0/go.mod"
	"github.com/jackc/pgx/v4 v4.6.1-0.20200510190926-94ba730bb1e9/go.mod"
	"github.com/jackc/pgx/v4 v4.6.1-0.20200606145419-4e5062306904/go.mod"
	"github.com/jackc/pgx/v4 v4.8.2-0.20200910143026-040df1ccef85"
	"github.com/jackc/pgx/v4 v4.8.2-0.20200910143026-040df1ccef85/go.mod"
	"github.com/jackc/puddle v0.0.0-20190413234325-e4ced69a3a2b/go.mod"
	"github.com/jackc/puddle v0.0.0-20190608224051-11cab39313c9/go.mod"
	"github.com/jackc/puddle v1.1.0/go.mod"
	"github.com/jackc/puddle v1.1.1/go.mod"
	"github.com/jackc/puddle v1.1.2-0.20200821025810-91d0159cc97a"
	"github.com/jackc/puddle v1.1.2-0.20200821025810-91d0159cc97a/go.mod"
	"github.com/josharian/intern v1.0.0"
	"github.com/josharian/intern v1.0.0/go.mod"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.2/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/pty v1.1.8/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/lib/pq v1.0.0/go.mod"
	"github.com/lib/pq v1.1.0/go.mod"
	"github.com/lib/pq v1.2.0/go.mod"
	"github.com/lib/pq v1.3.0"
	"github.com/lib/pq v1.3.0/go.mod"
	"github.com/mailru/easyjson v0.7.6"
	"github.com/mailru/easyjson v0.7.6/go.mod"
	"github.com/mattn/go-colorable v0.1.1/go.mod"
	"github.com/mattn/go-colorable v0.1.2/go.mod"
	"github.com/mattn/go-colorable v0.1.6/go.mod"
	"github.com/mattn/go-isatty v0.0.5/go.mod"
	"github.com/mattn/go-isatty v0.0.7/go.mod"
	"github.com/mattn/go-isatty v0.0.8/go.mod"
	"github.com/mattn/go-isatty v0.0.9/go.mod"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-sqlite3 v1.14.8"
	"github.com/mattn/go-sqlite3 v1.14.8/go.mod"
	"github.com/mediocregopher/radix/v3 v3.5.0"
	"github.com/mediocregopher/radix/v3 v3.5.0/go.mod"
	"github.com/memcachier/mc/v3 v3.0.1"
	"github.com/memcachier/mc/v3 v3.0.1/go.mod"
	"github.com/natefinch/npipe v0.0.0-20160621034901-c1b8fa8bdcce"
	"github.com/natefinch/npipe v0.0.0-20160621034901-c1b8fa8bdcce/go.mod"
	"github.com/omeid/go-yarn v0.0.1"
	"github.com/omeid/go-yarn v0.0.1/go.mod"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rogpeppe/go-internal v1.3.0/go.mod"
	"github.com/rs/xid v1.2.1/go.mod"
	"github.com/rs/zerolog v1.13.0/go.mod"
	"github.com/rs/zerolog v1.15.0/go.mod"
	"github.com/satori/go.uuid v1.2.0/go.mod"
	"github.com/shopspring/decimal v0.0.0-20180709203117-cd690d0c9e24/go.mod"
	"github.com/shopspring/decimal v0.0.0-20200227202807-02e2044944cc"
	"github.com/shopspring/decimal v0.0.0-20200227202807-02e2044944cc/go.mod"
	"github.com/sirupsen/logrus v1.4.1/go.mod"
	"github.com/sirupsen/logrus v1.4.2/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/objx v0.2.0/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.5.1"
	"github.com/stretchr/testify v1.5.1/go.mod"
	"github.com/zenazn/goji v0.9.0/go.mod"
	"go.uber.org/atomic v1.3.2/go.mod"
	"go.uber.org/atomic v1.4.0/go.mod"
	"go.uber.org/atomic v1.6.0/go.mod"
	"go.uber.org/multierr v1.1.0/go.mod"
	"go.uber.org/multierr v1.5.0/go.mod"
	"go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee/go.mod"
	"go.uber.org/zap v1.9.1/go.mod"
	"go.uber.org/zap v1.10.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190411191339-88737f569e3a/go.mod"
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
	"golang.org/x/crypto v0.0.0-20190820162420-60c769a6c586/go.mod"
	"golang.org/x/crypto v0.0.0-20190911031432-227b76d455e7/go.mod"
	"golang.org/x/crypto v0.0.0-20200323165209-0ec3e9974c59/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/lint v0.0.0-20190930215403-16217165b5de/go.mod"
	"golang.org/x/mod v0.0.0-20190513183733-4bf6d317e70e/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20190813141303-74dc4d7220e7"
	"golang.org/x/net v0.0.0-20190813141303-74dc4d7220e7/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e"
	"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
	"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
	"golang.org/x/sys v0.0.0-20190403152447-81d4e9dc473e/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod"
	"golang.org/x/sys v0.0.0-20190813064441-fde4db37ae7a/go.mod"
	"golang.org/x/sys v0.0.0-20190826190057-c7b8b68b1456/go.mod"
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod"
	"golang.org/x/sys v0.0.0-20210104204734-6f8348627aad"
	"golang.org/x/sys v0.0.0-20210104204734-6f8348627aad/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/text v0.3.3"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
	"golang.org/x/tools v0.0.0-20190425163242-31fd60d6bfdc/go.mod"
	"golang.org/x/tools v0.0.0-20190621195816-6e04913cbbac/go.mod"
	"golang.org/x/tools v0.0.0-20190823170909-c4a336ef6a2f/go.mod"
	"golang.org/x/tools v0.0.0-20191029041327-9cc4af7d6b2c/go.mod"
	"golang.org/x/tools v0.0.0-20191029190741-b9c20aec41a5/go.mod"
	"golang.org/x/xerrors v0.0.0-20190410155217-1f06c39b4373/go.mod"
	"golang.org/x/xerrors v0.0.0-20190513163551-3ee3066db522/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
	"gopkg.in/asn1-ber.v1 v1.0.0-20181015200546-f715ec2f112d"
	"gopkg.in/asn1-ber.v1 v1.0.0-20181015200546-f715ec2f112d/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/errgo.v2 v2.1.0/go.mod"
	"gopkg.in/inconshreveable/log15.v2 v2.0.0-20180818164646-67afb5ed74ec/go.mod"
	"gopkg.in/mgo.v2 v2.0.0-20190816093944-a6b53ec6cb22"
	"gopkg.in/mgo.v2 v2.0.0-20190816093944-a6b53ec6cb22/go.mod"
	"gopkg.in/natefinch/npipe.v2 v2.0.0-20160621034901-c1b8fa8bdcce"
	"gopkg.in/natefinch/npipe.v2 v2.0.0-20160621034901-c1b8fa8bdcce/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.8"
	"gopkg.in/yaml.v2 v2.2.8/go.mod"
	"honnef.co/go/tools v0.0.1-2019.2.3/go.mod"
)

go-module_set_globals

DESCRIPTION="ZABBIX is software for monitoring of your applications, network and servers"
HOMEPAGE="https://www.zabbix.com/"

MY_P=${P/_/}
MY_PV=${PV/_/}
SRC_URI="
	https://cdn.zabbix.com/${PN}/sources/development/$(ver_cut 1-2)/${PN}-${MY_PV}.tar.gz
	agent2? ( ${EGO_SUM_SRC_URI} )
"

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2)"
WEBAPP_MANUAL_SLOT="yes"
KEYWORDS="~amd64 ~x86"
IUSE="+agent +agent2 curl frontend gnutls ipv6 java ldap libxml2 mysql odbc openipmi +openssl oracle +postgres proxy server snmp sqlite ssh ssl static"
REQUIRED_USE="|| ( agent agent2 frontend proxy server )
	proxy? ( ^^ ( mysql oracle postgres sqlite ) )
	server? ( ^^ ( mysql oracle postgres ) )
	ssl? ( ^^ ( gnutls openssl ) )
	static? ( !oracle !snmp )"

COMMON_DEPEND="
	curl? ( net-misc/curl )
	java? ( >=virtual/jdk-1.8:* )
	ldap? (
		=dev-libs/cyrus-sasl-2*
		net-libs/gnutls
		net-nds/openldap
	)
	libxml2? ( dev-libs/libxml2 )
	mysql? ( dev-db/mysql-connector-c )
	odbc? ( dev-db/unixODBC )
	openipmi? ( sys-libs/openipmi )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql:* )
	proxy?  ( sys-libs/zlib )
	server? (
		dev-libs/libevent
		sys-libs/zlib
	)
	snmp? ( net-analyzer/net-snmp )
	sqlite? ( dev-db/sqlite )
	ssh? ( net-libs/libssh2 )
	ssl? (
		gnutls? ( net-libs/gnutls:0= )
		openssl? ( dev-libs/openssl:=[-bindist(-)] )
	)
"

RDEPEND="${COMMON_DEPEND}
	acct-group/zabbix
	acct-user/zabbix
	java? ( >=virtual/jre-1.8:* )
	mysql? ( virtual/mysql )
	proxy? ( net-analyzer/fping[suid] )
	server? (
		app-admin/webapp-config
		dev-libs/libevent
		dev-libs/libpcre
		net-analyzer/fping[suid]
	)
	frontend? (
		app-admin/webapp-config
		dev-lang/php:*[bcmath,ctype,sockets,gd,truetype,xml,session,xmlreader,xmlwriter,nls,sysvipc,unicode]
		media-libs/gd[png]
		virtual/httpd-php:*
		mysql? ( dev-lang/php[mysqli] )
		odbc? ( dev-lang/php[odbc] )
		oracle? ( dev-lang/php[oci8-instant-client] )
		postgres? ( dev-lang/php[postgres] )
		sqlite? ( dev-lang/php[sqlite] )
	)
"
DEPEND="${COMMON_DEPEND}
	static? (
		curl? ( net-misc/curl[static-libs] )
		ldap? (
			=dev-libs/cyrus-sasl-2*[static-libs]
			net-libs/gnutls[static-libs]
			net-nds/openldap[static-libs]
		)
		libxml2? ( dev-libs/libxml2[static-libs] )
		mysql? ( dev-db/mysql-connector-c[static-libs] )
		odbc? ( dev-db/unixODBC[static-libs] )
		postgres? ( dev-db/postgresql:*[static-libs] )
		sqlite? ( dev-db/sqlite[static-libs] )
		ssh? ( net-libs/libssh2 )
	)
"
BDEPEND="
	virtual/pkgconfig
"

# upstream tests fail for agent2
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.18-modulepathfix.patch"
	"${FILESDIR}/${PN}-3.0.30-security-disable-PidFile.patch"
)

S=${WORKDIR}/${MY_P}

ZABBIXJAVA_BASE="opt/zabbix_java"

pkg_setup() {
	if use oracle; then
		if [ -z "${ORACLE_HOME}" ]; then
			eerror
			eerror "The environment variable ORACLE_HOME must be set"
			eerror "and point to the correct location."
			eerror "It looks like you don't have Oracle installed."
			eerror
			die "Environment variable ORACLE_HOME is not set"
		fi
		if has_version 'dev-db/oracle-instantclient-basic'; then
			ewarn
			ewarn "Please ensure you have a full install of the Oracle client."
			ewarn "dev-db/oracle-instantclient* is NOT sufficient."
			ewarn
		fi
	fi

	if use frontend; then
		webapp_pkg_setup
	fi

	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default
}

src_configure() {
	econf \
		"$(use_enable agent)" \
		"$(use_enable agent2)" \
		"$(use_enable ipv6)" \
		"$(use_enable java)" \
		"$(use_enable proxy)" \
		"$(use_enable server)" \
		"$(use_enable static)" \
		"$(use_with curl libcurl)" \
		"$(use_with gnutls)" \
		"$(use_with ldap)" \
		"$(use_with libxml2)" \
		"$(use_with mysql)" \
		"$(use_with odbc unixodbc)" \
		"$(use_with openipmi openipmi)" \
		"$(use_with openssl)" \
		"$(use_with oracle)" \
		"$(use_with postgres postgresql)" \
		"$(use_with snmp net-snmp)" \
		"$(use_with sqlite sqlite3)" \
		"$(use_with ssh ssh2)"
}

src_compile() {
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
	fi
}

src_install() {
	local dirs=(
		/etc/zabbix
		/var/lib/zabbix
		/var/lib/zabbix/home
		/var/lib/zabbix/scripts
		/var/lib/zabbix/alertscripts
		/var/lib/zabbix/externalscripts
		/var/log/zabbix
	)

	for dir in "${dirs[@]}"; do
		dodir "${dir}"
		keepdir "${dir}"
	done

	if use server; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_server.conf
		fperms 0640 /etc/zabbix/zabbix_server.conf
		fowners root:zabbix /etc/zabbix/zabbix_server.conf

		newinitd "${FILESDIR}"/zabbix-server.init zabbix-server

		dosbin src/zabbix_server/zabbix_server

		insinto /usr/share/zabbix
		doins -r "${S}"/database/

		systemd_dounit "${FILESDIR}"/zabbix-server.service
		newtmpfiles "${FILESDIR}"/zabbix-server.tmpfiles zabbix-server.conf
	fi

	if use proxy; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_proxy.conf
		fperms 0640 /etc/zabbix/zabbix_proxy.conf
		fowners root:zabbix /etc/zabbix/zabbix_proxy.conf

		newinitd "${FILESDIR}"/zabbix-proxy.init zabbix-proxy

		dosbin src/zabbix_proxy/zabbix_proxy

		insinto /usr/share/zabbix
		doins -r "${S}"/database/

		systemd_dounit "${FILESDIR}"/zabbix-proxy.service
		newtmpfiles "${FILESDIR}"/zabbix-proxy.tmpfiles zabbix-proxy.conf
	fi

	if use agent; then
		insinto /etc/zabbix
		doins "${S}"/conf/zabbix_agentd.conf
		fperms 0640 /etc/zabbix/zabbix_agentd.conf
		fowners root:zabbix /etc/zabbix/zabbix_agentd.conf

		newinitd "${FILESDIR}"/zabbix-agentd.init zabbix-agentd

		dosbin src/zabbix_agent/zabbix_agentd
		dobin \
			src/zabbix_sender/zabbix_sender \
			src/zabbix_get/zabbix_get

		systemd_dounit "${FILESDIR}"/zabbix-agentd.service
		newtmpfiles "${FILESDIR}"/zabbix-agentd.tmpfiles zabbix-agentd.conf
	fi
	if use agent2; then
		insinto /etc/zabbix
		doins "${S}"/src/go/conf/zabbix_agent2.conf
		fperms 0640 /etc/zabbix/zabbix_agent2.conf
		fowners root:zabbix /etc/zabbix/zabbix_agent2.conf

		newinitd "${FILESDIR}"/zabbix-agent2.init zabbix-agent2

		dosbin src/go/bin/zabbix_agent2

		systemd_dounit "${FILESDIR}"/zabbix-agent2.service
		newtmpfiles "${FILESDIR}"/zabbix-agent2.tmpfiles zabbix-agent2.conf
	fi

	fowners root:zabbix /etc/zabbix
	fowners zabbix:zabbix \
		/var/lib/zabbix \
		/var/lib/zabbix/home \
		/var/lib/zabbix/scripts \
		/var/lib/zabbix/alertscripts \
		/var/lib/zabbix/externalscripts \
		/var/log/zabbix
	fperms 0750 \
		/etc/zabbix \
		/var/lib/zabbix \
		/var/lib/zabbix/home \
		/var/lib/zabbix/scripts \
		/var/lib/zabbix/alertscripts \
		/var/lib/zabbix/externalscripts \
		/var/log/zabbix

	dodoc README INSTALL NEWS ChangeLog \
		conf/zabbix_agentd.conf \
		conf/zabbix_proxy.conf \
		conf/zabbix_agentd/userparameter_examples.conf \
		conf/zabbix_agentd/userparameter_mysql.conf \
		conf/zabbix_server.conf

	if use frontend; then
		webapp_src_preinst
		cp -R ui/* "${D}/${MY_HTDOCSDIR}"
		webapp_configfile \
			"${MY_HTDOCSDIR}"/include/db.inc.php \
			"${MY_HTDOCSDIR}"/include/config.inc.php
		webapp_src_install
	fi

	if use java; then
		dodir \
			/${ZABBIXJAVA_BASE} \
			/${ZABBIXJAVA_BASE}/bin \
			/${ZABBIXJAVA_BASE}/lib
		keepdir /${ZABBIXJAVA_BASE}
		exeinto /${ZABBIXJAVA_BASE}/bin
		doexe src/zabbix_java/bin/zabbix-java-gateway-"${MY_PV}".jar
		exeinto /${ZABBIXJAVA_BASE}/lib
		doexe \
			src/zabbix_java/lib/logback-classic-1.2.3.jar \
			src/zabbix_java/lib/logback-console.xml \
			src/zabbix_java/lib/logback-core-1.2.3.jar \
			src/zabbix_java/lib/logback.xml \
			src/zabbix_java/lib/android-json-4.3_r3.1.jar \
			src/zabbix_java/lib/slf4j-api-1.7.30.jar
		newinitd "${FILESDIR}"/zabbix-jmx-proxy.init zabbix-jmx-proxy
		newconfd "${FILESDIR}"/zabbix-jmx-proxy.conf zabbix-jmx-proxy
	fi
}

pkg_postinst() {
	if use server || use proxy ; then
		elog
		elog "You may need to configure your database for Zabbix"
		elog "if you have not already done so."
		elog

		zabbix_homedir=$(egethome zabbix)
		if [ -n "${zabbix_homedir}" ] && \
			[ "${zabbix_homedir}" != "/var/lib/zabbix/home" ]; then
			ewarn
			ewarn "The user 'zabbix' should have his homedir changed"
			ewarn "to /var/lib/zabbix/home if you want to use"
			ewarn "custom alert scripts."
			ewarn
			ewarn "A real homedir might be needed for configfiles"
			ewarn "for custom alert scripts."
			ewarn
			ewarn "To change the homedir use:"
			ewarn "  usermod -d /var/lib/zabbix/home zabbix"
			ewarn
		fi
	fi

	if use server; then
		tmpfiles_process zabbix-server.conf

		elog
		elog "For distributed monitoring you have to run:"
		elog
		elog "zabbix_server -n <nodeid>"
		elog
		elog "This will convert database data for use with Node ID"
		elog "and also adds a local node."
		elog
	fi

	if use proxy; then
		tmpfiles_process zabbix-proxy.conf
	fi

	if use agent; then
		tmpfiles_process zabbix-agentd.conf
	fi

	if use agent2; then
		tmpfiles_process zabbix-agent2.conf
	fi

	elog "--"
	elog
	elog "You may need to add these lines to /etc/services:"
	elog
	elog "zabbix-agent     10050/tcp Zabbix Agent"
	elog "zabbix-agent     10050/udp Zabbix Agent"
	elog "zabbix-trapper   10051/tcp Zabbix Trapper"
	elog "zabbix-trapper   10051/udp Zabbix Trapper"
	elog

	if use server || use proxy ; then
		# check for fping
		fping_perms=$(stat -c %a /usr/sbin/fping 2>/dev/null)
		case "${fping_perms}" in
			4[157][157][157])
				;;
			*)
				ewarn
				ewarn "If you want to use the checks 'icmpping' and 'icmppingsec',"
				ewarn "you have to make /usr/sbin/fping setuid root and executable"
				ewarn "by everyone. Run the following command to fix it:"
				ewarn
				ewarn "  chmod u=rwsx,g=rx,o=rx /usr/sbin/fping"
				ewarn
				ewarn "Please be aware that this might impose a security risk,"
				ewarn "depending on the code quality of fping."
				ewarn
				;;
		esac
	fi
}

pkg_prerm() {
	(use frontend || use server) && webapp_pkg_prerm
}
