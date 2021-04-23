# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="TODO"

ACCT_USER_ID=118
ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_HOME="/opt/${PN}"
ACCT_USER_SHELL="/bin/bash"

acct-user_add_deps
