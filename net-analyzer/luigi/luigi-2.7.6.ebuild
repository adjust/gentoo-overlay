# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=(python{2_7,3_3,3_4,3_5,3_6})

inherit distutils-r1

DESCRIPTION="Workflow mgmgt + task scheduling + dependency resolution"
HOMEPAGE="https://github.com/spotify/luigi"
SRC_URI="https://github.com/spotify/luigi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="=www-servers/tornado-4*
	<dev-python/python-daemon-3.0"

python_install() {
	distutils-r1_python_install
	newinitd "${FILESDIR}"/${P}.init ${PN}
}
