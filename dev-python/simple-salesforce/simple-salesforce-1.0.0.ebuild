# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Basic Salesforce.com REST API client."
HOMEPAGE="https://pypi.org/project/simple-salesforce/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE=""

DEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/Authlib[${PYTHON_USEDEP}]
"
