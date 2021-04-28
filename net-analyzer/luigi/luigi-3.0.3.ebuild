# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-r1

DESCRIPTION="Workflow mgmgt + task scheduling + dependency resolution"
HOMEPAGE="https://github.com/spotify/luigi"
SRC_URI="https://github.com/spotify/luigi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	www-servers/tornado
	<dev-python/python-daemon-3.0
	dev-python/dateutil
"

DEPEND="
	${RDEPEND}
"

python_install() {
	distutils-r1_python_install
	newinitd "${FILESDIR}"/${P}.init ${PN}
	keepdir /var/lib/luigi-server
}
