# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A tool that collects configuration details from a Linux system"
HOMEPAGE="https://github.com/sosreport/sos"
SRC_URI="https://github.com/sosreport/sos/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pycodestyle
	dev-python/coverage
	dev-python/sphinx
	dev-python/pyyaml
"

PATCHES=(
	"${FILESDIR}/${P}-setup-py.patch"
)

python_install_all() {
	distutils-r1_python_install_all
	dodoc AUTHORS README.md
	insinto /etc
	doins sos.conf
}
