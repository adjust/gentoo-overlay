# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.9"
KEYWORDS="amd64"

RDEPEND="|| (
		dev-java/icedtea-bin:9
		dev-java/icedtea:9
		dev-java/oracle-jdk-bin:1.9
	)"
