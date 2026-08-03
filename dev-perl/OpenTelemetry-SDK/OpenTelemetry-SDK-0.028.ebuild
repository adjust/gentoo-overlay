# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JJATRIA"
DIST_VERSION="0.028"

inherit perl-module

DESCRIPTION="OpenTelemetry::SDK - A Perl implementation of the OpenTelemetry SDK"
HOMEPAGE="https://metacpan.org/dist/OpenTelemetry-SDK"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
  dev-perl/Module-Build-Tiny
"

DEPEND="
	dev-perl/Feature-Compat-Try
	dev-perl/Future-AsyncAwait
	dev-perl/IO-Async
	virtual/perl-Math-BigInt
	dev-perl/Metrics-Any
	dev-perl/Mutex
	>=dev-perl/Object-Pad-0.740.0
	>=dev-perl/OpenTelemetry-0.030
	dev-perl/OpenTelemetry-Exporter-OTLP
"

RDEPEND="
	${DEPEND}
"
