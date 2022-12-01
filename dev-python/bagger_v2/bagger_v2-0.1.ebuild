# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# structlog supports python9..11
# newrelic supports python8..9
PYTHON_COMPAT=( python3_9 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Adjust Bagger pull.pl python wrapper"
HOMEPAGE="https://github.com/adjust/bagger_v2"
SRC_URI="https://github.com/adjust/bagger_v2/archive/v${PV}.tar.gz -> bagger_v2-${PV}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="fetch"

RDEPEND="
	dev-python/structlog[${PYTHON_USEDEP}]
	>dev-python/newrelic-8[${PYTHON_USEDEP}]
"

pkg_nofetch() {
	[ -z "${SRC_URI}" ] && return

	# May I have your attention please
	einfo "**************************"
	einfo "Please manually download"
	einfo "$SRC_URI"
	einfo "and put it on binhost"
	einfo "**************************"
}

src_prepare() {
	# setuptool-scm can not determine version number using the release tarball.
	sed -i \
		-e "s|use_scm_version.*|version='${PV}',|" \
		-e '/setup_requires/d' setup.py || die 'sed failed'
	default
}
