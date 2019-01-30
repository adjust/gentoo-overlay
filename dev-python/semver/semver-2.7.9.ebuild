# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A Python module for semantic versioning. Simplifies comparing versions."
HOMEPAGE="https://github.com/k-bx/python-semver"
LICENSE="BSD"
SLOT="0"
IUSE="doc"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/k-bx/python-semver"
	inherit git-r3
else
	SRC_URI="https://github.com/k-bx/python-semver/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
fi

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/guzzle_sphinx_theme[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	${EPYTHON} setup.py test || die "test failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}

