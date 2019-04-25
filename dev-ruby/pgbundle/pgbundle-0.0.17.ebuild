# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="bundler like postgres extension manager"
HOMEPAGE="https://github.com/adjust/pgbundle"
SRC_URI="https://rubygems.org/downloads/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	dev-ruby/net-scp
	dev-ruby/net-ssh
	dev-ruby/pg
	dev-ruby/thor
	dev-ruby/zip
	"
