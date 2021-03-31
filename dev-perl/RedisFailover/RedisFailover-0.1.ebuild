# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module git-r3

DESCRIPTION="Redis failover scripts"
HOMEPAGE="https://github.com/adjust/redis_failover"

SLOT="0"
KEYWORDS="~amd64"
LICENSE="MIT"

IUSE=""

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/adjust/redis_failover.git"
else
	SRC_URI="https://github.com/adjust/redis_failover/archive/v${PVR}.tar.gz"
fi

DEPEND="
	dev-perl/Moo
	dev-perl/Redis
	dev-perl/YAML
	dev-perl/Linux-Inotify2
	dev-perl/Module-Build
"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack v${PVR}.tar.gz
	mv redis_failover-${PVR} ${PN}-${PV}
}

src_install() {
	perl-module_src_install
	newinitd "${FILESDIR}/failover_watch" failover_watch
}
