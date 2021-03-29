# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for cron"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="|| ( sys-process/vixie-cron
		sys-process/cronie
		sys-process/bcron
		sys-process/dcron
		sys-process/fcron
		)"
