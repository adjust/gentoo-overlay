# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for dev-python/jupyterhub"

ACCT_USER_ID=-1
ACCT_USER_HOME="/var/lib/jupyterhub"
ACCT_USER_GROUPS=( jupyterhub )

acct-user_add_deps
