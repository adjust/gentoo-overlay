# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE="BeerBSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-libs/gloox
		dev-db/mongodb
		>=dev-lang/lua-5.1.0
		dev-libs/openssl"

RDEPEND="${DEPEND}"

EGIT_REPO_URI="https://github.com/mueller-wulff/zabbix_xmpp.git"

src_prepare() {
	if [ ! -d ${PORTAGE_BUILDDIR}/certs ]; then
		mkdir -p ${PORTAGE_BUILDDIR}/certs
	fi
}

src_compile() {
	make release || die "Something went terribly wrong..."
	bash script/createCerts.sh ${PORTAGE_BUILDDIR}/certs
}

src_install() {
	dodir /usr/certs/
	cp "${PORTAGE_BUILDDIR}/certs/certreq.csr" "${D}/usr/certs/"
	cp "${PORTAGE_BUILDDIR}/certs/roakey.pem" "${D}/usr/certs/"
	cp "${PORTAGE_BUILDDIR}/certs/roacert.pem" "${D}/usr/certs/"

    dodir /usr/bin/
	cp "${PORTAGE_BUILDDIR}/work/zabbix_bot-0.01/bin/Release/zabbix_xmpp" \
	"${D}/usr/bin/" || die
	
	dodir /etc/zabbix_bot
	cp "${PORTAGE_BUILDDIR}/work/zabbix_bot-0.01/config/bot.lua" \
	"${D}/etc/zabbix_bot" || die

	doinitd "${FILESDIR}"/init.d/zabbix_bot
}
