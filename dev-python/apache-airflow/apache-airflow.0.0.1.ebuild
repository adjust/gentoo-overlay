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

RDEPEND=">=dev-python/click-8.1.3
	>=dev-python/jinja-3.1.2
	>=dev-python/keyring-23.6.0
	>=dev-python/PyGithub-1.55-r1
	>=dev-python/jsonschema-4.7.2
	>=dev-python/pendulum-2.1.2-r1
	>=dev-python/pyyaml-6.0-r1
	>=dev-python/packaging-21.3-r3
	>=dev-python/rich-12.5.1
	>=dev-python/semver-2.13.0
	>=dev-python/0.8.10"
