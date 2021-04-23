# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Redis failover scripts"
HOMEPAGE="https://github.com/adjust/redis_failover"

SLOT="0"
LICENSE="MIT"

IUSE=""

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adjust/redis_failover.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/adjust/redis_failover/archive/v${PVR}.tar.gz -> ${P}.tar.gz"
fi

BDEPEND="
	dev-perl/Module-Build
"

DEPEND="
	dev-perl/Moo
	dev-perl/Redis
	dev-perl/YAML
	dev-perl/Linux-Inotify2
	dev-perl/Module-Build
"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${P}.tar.gz
	mv redis_failover-${PVR} ${PN}-${PV}
}

src_install() {
	perl-module_src_install
	newinitd "${FILESDIR}/failover_watch" failover_watch
}
