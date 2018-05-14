# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Ruby aerospike client"
HOMEPAGE="http://www.github.com/aerospike/aerospike-client-ruby https://rubygems.org/gems/aerospike/versions/1.0.11"
SRC_URI="https://rubygems.org/downloads/${P}.gem"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	dev-ruby/msgpack
	dev-ruby/bcrypt
	"
