# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module git-r3

DESCRIPTION="redis failover scripts"
HOMEPAGE="https://github.com/adjust/redis_failover"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/redis_failover.git"

LICENSE="MIT"
KEYWORDS=""

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Moo
	dev-perl/Redis
	dev-perl/YAML
	dev-perl/Linux-Inotify2
	dev-perl/Module-Build
"

RDEPEND="
	${DEPEND}
"

src_install() {
	perl-module_src_install
	newinitd "${FILESDIR}/failover_watch" failover_watch
}
