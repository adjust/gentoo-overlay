# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JJATRIA"
DIST_VERSION="0.035"

inherit perl-module

DESCRIPTION="OpenTelemetry - A vendor-neutral observability framework for Perl"
HOMEPAGE="https://metacpan.org/dist/OpenTelemetry"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
  dev-perl/Module-Build-Tiny
"

DEPEND="
	>=virtual/perl-Scalar-List-Utils-1.450.0
	dev-perl/Bytes-Random-Secure
	dev-perl/Carp-Clan
	dev-perl/Class-Method-Modifiers
	dev-perl/Exporter-Tiny
	dev-perl/Feature-Compat-Defer
	dev-perl/Feature-Compat-Try
	dev-perl/Future
	dev-perl/Future-AsyncAwait
	dev-perl/Log-Any
	dev-perl/Module-Pluggable
	dev-perl/Module-Runtime
	dev-perl/Mutex
	>=dev-perl/Object-Pad-0.740.0
	dev-perl/Ref-Util
	dev-perl/Sentinel
	dev-perl/Syntax-Keyword-Dynamically
	dev-perl/URI
	dev-perl/URL-Encode
	dev-perl/UUID-URandom
	dev-perl/X-Tiny
"

RDEPEND="
	${DEPEND}
"
