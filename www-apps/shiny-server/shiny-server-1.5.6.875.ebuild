# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A host for Shiny Apps"
HOMEPAGE="https://github.com/rstudio/shiny-server"
SRC_URI="https://github.com/rstudio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND="
	dev-lang/python:2.7
"

DEPEND="
	${RDEPEND}
"

# TODO: unbundle nodejs
#IUSE="+system-nodejs"

BUILD_PYTHON="python2"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt
		-DPYTHON="${BUILD_PYTHON}"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

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
	cmake_src_install
	fowners -R shiny:shiny /opt/shiny-server

	dodir /etc/shiny-server
	insinto /etc/shiny-server/
	doins "${WORKDIR}/${PF}"/config/*
	doins "${FILESDIR}/shiny-server.conf"

	dodir /var/log/shiny-server
	fowners -R shiny:shiny /var/log/shiny-server

	dodir /var/lib/shiny-server

	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
}
