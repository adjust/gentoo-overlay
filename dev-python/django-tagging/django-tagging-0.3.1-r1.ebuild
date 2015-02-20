# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Generic tagging application for Django"
HOMEPAGE="http://code.google.com/p/django-tagging/"
SRC_URI="http://django-tagging.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/django[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
