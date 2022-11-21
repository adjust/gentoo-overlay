# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Manage versions by scm tags via setuptools"
HOMEPAGE="
	https://github.com/pypa/setuptools_scm/
	https://pypi.org/project/setuptools-scm/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-vcs/git
		!sparc? (
			dev-vcs/mercurial
		)
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fetching from the Internet
	testing/test_regressions.py::test_pip_download
	testing/test_setuptools_support.py

	# broken by setuptools pyproject.toml validation
	testing/test_integration.py::test_pyproject_support
)
