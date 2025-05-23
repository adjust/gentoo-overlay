# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..12} )

inherit distutils-r1

DESCRIPTION="Implement minimal boilerplate CLIs derived from type hints and parse from command line, config files and environment variables."
HOMEPAGE="https://github.com/omni-us/jsonargparse"
SRC_URI="https://github.com/omni-us/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	>dev-python/pyyaml-3.13[${PYTHON_USEDEP}]
"

BDEPEND=${RDEPEND}
