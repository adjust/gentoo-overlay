# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils user

DESCRIPTION="A host for Shiny Apps"
HOMEPAGE="https://github.com/rstudio/shiny-server"

SLOT="0"

RDEPEND=""
DEPEND="dev-lang/python:2.7"

# TODO: unbundle nodejs
#IUSE="+system-nodejs"

LICENSE="AGPL-3"

KEYWORDS="~x86 ~amd64"
SRC_URI="https://github.com/rstudio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

BUILD_PYTHON="python2"

pkg_setup() {
	enewgroup shiny
	enewuser shiny -1 -1 /opt/shiny-server shiny
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt
		-DPYTHON="${BUILD_PYTHON}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	# TODO: we requre shiny-servers bundled nodejs
	# until we can unbundle it. 
	pushd "${WORKDIR}/${PF}"
	./bin/npm --python="${BUILD_PYTHON}" install || die
	./bin/npm --python="${BUILD_PYTHON}" rebuild || die
	./bin/node ./ext/node/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js \
		--python="${BUILD_PYTHON}" rebuild || die
	popd
}

src_install() {
	cmake-utils_src_install
	fowners -R shiny:shiny /opt/shiny-server

	dodir /etc/shiny-server
	insinto /etc/shiny-server/
	doins "${WORKDIR}/${PF}"/config/*
	doins "${FILESDIR}/shiny-server.conf"

	fowners -R shiny:shiny /etc/shiny-server

	dodir /var/log/shiny-server
	fowners -R shiny:shiny /var/log/shiny-server

	dodir /var/lib/shiny-server

	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
}
