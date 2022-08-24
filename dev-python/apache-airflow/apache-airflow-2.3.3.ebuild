# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Apache Airflow"
HOMEPAGE="https://github.com/apache/airflow"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"

BDEPEND="
	dev-python/GitPython[${PYTHON_USEDEP}]
"
RDEPEND=">=dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.1.0[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/pendulum[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/semver[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
"
