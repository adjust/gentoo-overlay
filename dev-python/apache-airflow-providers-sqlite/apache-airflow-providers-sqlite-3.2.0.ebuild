# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Apache Airflow providers sqlite package."
HOMEPAGE="https://pypi.org/project/apache-airflow-providers-sqlite"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"

BDEPEND="dev-python/GitPython[${PYTHON_USEDEP}]"
RDEPEND="dev-python/apache-airflow-providers-common-sql[${PYTHON_USEDEP}]"
