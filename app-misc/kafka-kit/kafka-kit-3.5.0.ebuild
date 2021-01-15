# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base user

EGO_PN="github.com/DataDog/kafka-kit"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Kafka topic management tools"
HOMEPAGE="https://github.com/DataDog/kafka-kit"
LICENSE="Apache"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-lang/go-1.5
"

src_compile() {
	export BUILD="${PV}"
	emake
}

src_install() {
	dobin "${PN}"
	dodoc README.md
}
