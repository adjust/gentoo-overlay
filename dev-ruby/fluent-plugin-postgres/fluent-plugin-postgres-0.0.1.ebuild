# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"
inherit ruby-fakegem

DESCRIPTION="fluent plugin to insert on PostgreSQL"
HOMEPAGE="https://rubygems.org/gems/fluent-plugin-postgres"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-admin/fluentd
"
RDEPEND="${DEPEND}"
ruby_add_bdepend 'dev-ruby/pg'
