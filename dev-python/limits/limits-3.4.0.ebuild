# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python module for enforcing limits on system resources"
HOMEPAGE="https://github.com/benosman/limits"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	>=dev-python/importlib-resources-1.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-21[${PYTHON_USEDEP}]
	>=dev-python/deprecated-1.2[${PYTHON_USEDEP}]
    dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	einstalldocs
}
