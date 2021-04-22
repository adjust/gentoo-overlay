# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Slack bot for karma tracking using reaction buttons"
HOMEPAGE="https://github.com/adjust/karmabot"
SRC_URI="https://files.adjust.com/karmabot-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	acct-group/karmabot
	acct-user/karmabot
"

DEPEND="
	${RDEPEND}
"

DAEMON_USER="karmabot"
LOG_DIR="/var/log/karmabot"

S="${WORKDIR}"

src_install() {
	dobin "karmabot"
	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"

	keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}" "${LOG_DIR}"
}
