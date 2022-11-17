# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A supervisor that manages ephemeral github runners"
HOMEPAGE="https://www.sonarqube.org/"
SRC_URI="https://binaries.sonarsource.com/CommercialDistribution/${PN}/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

BDEPEND="
	app-arch/unzip
"

RDEPEND="
	acct-group/sonarqube
	acct-user/sonarqube
	dev-java/openjdk-bin
"

PATCHES=(
	"${FILESDIR}/pidfile.patch"
	"${FILESDIR}/exit-codes.patch"
	"${FILESDIR}/configuration.patch"
)

src_unpack() {
	unpack ${P}.zip
	mv sonarqube-${PV} ${P} || die
}

src_install() {
	insinto /opt
	doins -r "${S}"

	newinitd "${FILESDIR}/init" sonarqube

	keepdir /var/lib/sonarqube/data /var/lib/sonarqube/temp /var/lib/sonarqube/downloads/
	keepdir /var/log/sonarqube

	dosym "/opt/${P}/conf" /etc/sonarqube
	dosym "/opt/${P}" /opt/sonarqube
	dosym /var/lib/sonarqube/downloads/ "/opt/${P}/extensions/downloads"
}

pkg_preinst() {
	fowners sonarqube:sonarqube "/var/lib/sonarqube/data" "/var/lib/sonarqube/temp"
	fowners sonarqube:sonarqube "/var/log/sonarqube"

	fperms 755 "/opt/${P}/bin/linux-x86-64/sonar.sh"
	fperms 755 "/opt/${P}/bin/linux-x86-64/wrapper"
	fperms 755 "/opt/${P}/elasticsearch/bin/elasticsearch"
}
