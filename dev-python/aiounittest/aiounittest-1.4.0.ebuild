# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Test python asyncio-based code with ease"
HOMEPAGE="https://github.com/kwarunek/aiounittest"
SRC_URI="https://github.com/kwarunek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"

SLOT="0"

RDEPEND="dev-python/wrapt[${PYTHON_USEDEP}]"

distutils_enable_tests nose
# Reason: TemplateNotFound('g')
#distutils_enable_sphinx docs
