# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="shovel data around"
HOMEPAGE="https://github.com/adjust/schaufel"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/adjust/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"

SLOT="0"

IUSE="doc"

RDEPEND="
	acct-group/schaufel
	acct-user/schaufel
	dev-libs/librdkafka[lz4]
	dev-libs/hiredis
	dev-db/postgresql
	dev-libs/json-c
	>=dev-libs/libconfig-1.7
	doc? (
		sys-apps/groff
		app-text/ghostscript-gpl
	)
"

DEPEND="
	${RDEPEND}
"

src_compile() {
	default
	use doc && emake docs
}

src_install() {
	export PREFIX="/usr"
	export DOCDIR="${PREFIX}/share/doc/${P}"
	default

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	diropts -m 0755 -o ${PN} -g ${PN}
	keepdir /var/{log,lib}/${PN}
}
