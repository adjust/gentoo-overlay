# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Hunter is a flexible code tracing toolkit"
HOMEPAGE="https://pypi.org/project/hunter"
SRC_URI="https://github.com/ionelmc/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	test? (
		dev-python/aspectlib[${PYTHON_USEDEP}]
		dev-python/ipdb[${PYTHON_USEDEP}]
		dev-python/manhole[${PYTHON_USEDEP}]
		dev-python/process-tests[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-3.3.1[${PYTHON_USEDEP}]
"

S="${WORKDIR}/python-${P}"

PATCHES=( "${FILESDIR}/remove-setuptools_scm-upper-constraint.patch" )

distutils_enable_tests pytest
distutils_enable_sphinx docs ">=dev-python/sphinx-py3doc-enhanced-theme-2.3.2"

python_prepare_all() {
	# all tests in this file fail
	rm tests/test_remote.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile

	if use test; then
		"${EPYTHON}" tests/setup.py build_ext --force --inplace || die
	fi
}

python_test() {
	local -x PYTHONPATH="${S}/tests:${BUILD_DIR}/lib:${PYTHONPATH}"
	epytest
}
