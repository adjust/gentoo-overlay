# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit perl-module git-2

DESCRIPTION="redis failover scripts"
HOMEPAGE="https://github.com/adjust/redis_failover"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/redis_failover.git"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-perl/Moo
	dev-perl/Redis
	dev-perl/YAML
	dev-perl/Linux-Inotify2
	dev-perl/Module-Build
"

RDEPEND="${DEPEND}"

src_install() {
	perl-module_src_install
	newinitd "${FILESDIR}/failover_watch" failover_watch
}
