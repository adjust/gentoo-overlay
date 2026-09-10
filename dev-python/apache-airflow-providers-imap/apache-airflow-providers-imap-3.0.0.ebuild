# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Apache Airflow providers imap package."
HOMEPAGE="https://pypi.org/project/apache-airflow-providers-imap"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

RESTRICT="test"

BDEPEND="dev-python/GitPython[${PYTHON_USEDEP}]"
