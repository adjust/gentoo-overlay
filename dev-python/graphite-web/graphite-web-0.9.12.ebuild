# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

WEBAPP_MANUAL_SLOT="yes"

inherit distutils webapp eutils

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="http://graphite.wikidot.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/python[sqlite]
	dev-python/carbon
	dev-python/django
	dev-python/pycairo
	dev-python/twisted-web
	dev-python/whisper
	dev-python/django-tagging"

src_prepare () {
	rm ${S}/setup.cfg
#	epatch ${FILESDIR}/data-dir.patch
}

pkg_setup () {
	python_pkg_setup
	webapp_pkg_setup
}

src_install () {
	distutils_src_install
	webapp_src_preinst
	insinto ${MY_HTDOCSDIR}
	doins -r webapp/content/*
	webapp_src_install
}
