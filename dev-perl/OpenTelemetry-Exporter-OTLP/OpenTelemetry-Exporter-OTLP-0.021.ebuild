# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JJATRIA"
DIST_VERSION="0.021"

inherit perl-module

DESCRIPTION="OpenTelemetry::Exporter::OTLP - OTLP exporter for OpenTelemetry"
HOMEPAGE="https://metacpan.org/dist/OpenTelemetry-Exporter-OTLP"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Feature-Compat-Try
	dev-perl/File-Share
	dev-perl/Future-AsyncAwait
	dev-perl/HTTP-Tiny
	dev-perl/JSON-MaybeXS
	dev-perl/Metrics-Any
	>=dev-perl/Object-Pad-0.740.0
	>=dev-perl/OpenTelemetry-0.030
	dev-perl/Path-Tiny
	dev-perl/Syntax-Keyword-Dynamically
	dev-perl/Syntax-Keyword-Match
	dev-perl/Time-Piece
"

RDEPEND="
	${DEPEND}
"
