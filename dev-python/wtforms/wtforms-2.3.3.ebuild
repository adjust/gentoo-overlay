# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=WTForms
inherit distutils-r1 pypi

DESCRIPTION="Flexible forms validation and rendering library for python web development"
HOMEPAGE="https://wtforms.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/markupsafe[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/Babel[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/python-email-validator[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# use pytest instead of ugly custom test runner
	cat >> setup.cfg <<-EOF || die
		[tool:pytest]
		python_files = *.py
	EOF

	distutils-r1_python_prepare_all
}

python_test() {
	local ignore=(
		# requires gaetest_common... also upstream doesn't run it at all
		tests/ext_appengine
		# requires old django; also extensions are deprecated anyway
		tests/ext_django
	)
	local deselect=(
		# incompatible with sqlalchemy-1.4
		tests/ext_sqlalchemy.py::QuerySelectFieldTest
		tests/ext_sqlalchemy.py::QuerySelectMultipleFieldTest
	)

	epytest tests ${ignore[@]/#/--ignore } ${deselect[@]/#/--deselect }
}
