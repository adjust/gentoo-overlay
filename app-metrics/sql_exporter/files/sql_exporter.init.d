#!/sbin/openrc-run
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

name="sql_exporter daemon"
description="SQL Exporter allows to run custom queries against a database"
command="/usr/bin/sql_exporter"
command_args="-config.file /etc/sql_exporter/sql_exporter.yml"
start_stop_daemon_args="--user sql_exporter"
output_log="/var/log/sql_exporter/sql_exporter.log"
error_log="/var/log/sql_exporter/sql_exporter.log"

depend() {
    need net
}
