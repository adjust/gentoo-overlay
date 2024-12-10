# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..12} )

inherit distutils-r1

DESCRIPTION="Python API client library for NetBox."
HOMEPAGE="https://github.com/netbox-community/pynetbox"
SRC_URI="https://github.com/netbox-community/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	<dev-python/requests-3
	<dev-python/urllib3-3
	dev-python/packaging
"

BDEPEND=${RDEPEND}

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
