# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Telemetry for Jupyter Applications and extensions"
HOMEPAGE="https://github.com/jupyter/telemetry"
SRC_URI="mirror://pypi/${PN:0:1}/jupyter_telemetry/jupyter_telemetry-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND="\
	dev-python/ruamel-yaml[${PYTHON_USEDEP}] \
	dev-python/jsonschema[${PYTHON_USEDEP}] \
	dev-python/python-json-logger[${PYTHON_USEDEP}] \
	dev-python/traitlets[${PYTHON_USEDEP}] \
"


src_unpack() {
	default
	mv * ${P}
}

src_prepare() {
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
	distutils-r1_python_install_all
}
