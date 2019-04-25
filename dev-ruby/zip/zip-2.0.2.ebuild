# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Ruby library for reading and writing Zip files"
HOMEPAGE="https://rubygems.org/gems/zip"
SRC_URI="https://rubygems.org/downloads/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
