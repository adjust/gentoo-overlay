#!/sbin/openrc-run
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

name="sql_exporter daemon"
description="SQL Exporter allows to run custom queries against a database"

depend() {
    need net
}

start() {
    ebegin "Starting sql_exporter"
    start-stop-daemon --start --chuid sql_exporter --exec /usr/bin/sql_exporter -- \
        -config.file /etc/sql_exporter/sql_exporter.yml \
        >> /var/log/sql_exporter/sql_exporter.log 2>&1 &
    eend $?
}

stop() {
    ebegin "Stopping sql_exporter"
    start-stop-daemon --stop --quiet --exec /usr/bin/sql_exporter
    eend $?
}
