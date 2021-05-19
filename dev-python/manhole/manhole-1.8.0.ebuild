# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_8 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="python-${PN}"

DESCRIPTION="Debugging manhole for python application"
HOMEPAGE="https://pypi.org/project/manhole"
SRC_URI="https://github.com/ionelmc/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64"

SLOT="0"

DEPEND="
	test? (
		dev-python/eventlet[${PYTHON_USEDEP}]
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/process-tests[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
				dev-python/sphinx-py3doc-enhanced-theme \
				dev-python/sphinxcontrib-napoleon

python_test() {
	distutils_install_for_testing
	epytest \
			--deselect tests/test_manhole.py::test_non_daemon_connection \
			--deselect tests/test_manhole.py::test_daemon_connection \
			--deselect tests/test_manhole.py::test_uwsgi \
			--deselect tests/test_manhole.py::test_fork_exec \
			--deselect tests/test_manhole.py::test_connection_handler_exec[str] \
			--deselect tests/test_manhole.py::test_connection_handler_exec[func] \
			--deselect tests/test_manhole.py::test_environ_variable_activation \
			--deselect tests/test_manhole_cli.py::test_help

}
