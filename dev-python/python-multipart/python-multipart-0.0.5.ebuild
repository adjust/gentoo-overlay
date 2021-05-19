# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A streaming multipart parser for Python"
HOMEPAGE="https://andrew-d.github.io/python-multipart"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

# RuntimeError: Unsafe load() call disabled by Gentoo. See bug #659348
RESTRICT="test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# there are docs on github, but there is no 0.0.5 release tarball there for some reason
#distutils_enable_sphinx docs/source dev-python/sphinx-bootstrap-theme
