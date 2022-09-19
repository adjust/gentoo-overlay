# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Telemetry collector for sending data to Grafana - binary package"
HOMEPAGE="https://github.com/grafana/agent"
SRC_URI="
	https://github.com/grafana/agent/releases/download/v${PV}/agent-linux-amd64.zip -> ${P}.zip
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-arch/zip"

QA_PREBUILT="/opt/bin/grafana-agent"
QA_PRESTRIPPED="/opt/bin/grafana-agent"

RESTRICT="mirror strip"

src_install() {
	into /opt
	newbin agent-linux-amd64 grafana-agent
}
