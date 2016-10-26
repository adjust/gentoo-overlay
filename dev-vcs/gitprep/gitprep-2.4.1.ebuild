# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module user versionator git-r3

DESCRIPTION="Github clone. you can install Github system into your unix/linux machine."
HOMEPAGE="http://gitprep.yukikimoto.com/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/yuki-kimoto/gitprep"
#VERSION 2.4.1
EGIT_COMMIT="c3e7ef3f17e0daee47f65dc77e5fbf829f8d02ae"
LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DATADIR="/var/lib/gitprep"
USER="git"

RDEPEND="
	dev-perl/Mojolicious-Plugin-INIConfig
	dev-perl/Mojolicious
	dev-perl/Mojolicious-Plugin-AutoRoute
	dev-perl/Mojolicious-Plugin-BasicAuth
	dev-perl/Mojolicious-Plugin-DBViewer
	dev-perl/DBIx-Connector
	dev-perl/DBIx-Custom
	dev-perl/DBD-SQLite
	dev-perl/Text-Markdown-Hoedown
	dev-perl/Data-Page
	virtual/perl-Module-CoreList
	dev-perl/Config-Tiny
	dev-perl/Time-Moment
	dev-perl/Object-Simple
	dev-perl/Validator-Custom
"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup ${USER}
	enewuser ${USER} -1 /bin/bash "${DATADIR}" ${USER}
}

src_compile() {
	./setup_database
}

src_install() {
	insinto "${DATADIR}"
	doins -r ./*
	fowners -R "${USER}:${USER}" "${DATADIR}"
}
