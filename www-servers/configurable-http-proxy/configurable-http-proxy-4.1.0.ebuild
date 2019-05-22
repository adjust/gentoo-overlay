# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A simple wrapper around node-http-proxy"
HOMEPAGE="https://github.com/jupyterhub/configurable-http-proxy"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/nodejs"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	insinto "opt/${PN}"
	doins -r .

	into opt/${PN}/node_modules/${PN}
	dobin node_modules/${PN}/bin/${PN}

	dosym "${ED%/}"/opt/${PN}/node_modules/${PN}/bin/${PN} /usr/bin/${PN}
}
