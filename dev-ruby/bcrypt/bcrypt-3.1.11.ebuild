# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Ruby bcrypt"
HOMEPAGE="https://github.com/codahale/bcrypt-ruby"
SRC_URI="https://rubygems.org/downloads/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	dev-ruby/msgpack
	"

all_ruby_prepare() {
	mkdir -p lib
}

each_ruby_configure() {
	${RUBY} -Cext/mri/ extconf.rb || die "Unable to configure extension."
}

each_ruby_compile() {
	emake -Cext/mri V=1
	cp ext/mri/bcrypt_ext.so lib/ || die "Unable to copy extension."
}

