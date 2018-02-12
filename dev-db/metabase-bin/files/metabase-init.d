#!/sbin/openrc-run
# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

description="Metabase"

logfile="/var/log/metabase/metabase.log"

command="/opt/metabase/bin/metabase-server-start.sh"

command_background=yes
pidfile=/run/${SVCNAME}.pid

start() {
	start-stop-daemon --start --background --user metabase \
	--chdir /opt/metabase/lib --stdout $logfile --stderr $logfile \
	--env METABASE_HEAP_OPTS="${METABASE_HEAP_OPTS}" \
	--env METABASE_LOG4J_FILE="${METABASE_LOG4J_FILE}" \
	--env METABASE_BIND_ADDR="${METABASE_BIND_ADDR}" \
	--env METABASE_SSL="${METABASE_SSL}" \
	--env METABASE_KEYSTORE="${METABASE_KEYSTORE}" \
	--env METABASE_KEYSTORE_PASSWORD="${METABASE_KEYSTORE_PASSWORD}" \
	--env METABASE_PASSWORD_COMPLEXITY="${METABASE_PASSWORD_COMPLEXITY}" \
	--env METABASE_PASSWORD_LENGTH="${METABASE_PASSWORD_LENGTH}" \
	--env METABASE_ENCRYPTION_SECRET_KEY="${METABASE_ENCRYPTION_SECRET_KEY}" \
	--env METABASE_DB_TYPE="${METABASE_DB_TYPE}" \
	--env METABASE_DB_DBNAME="${METABASE_DB_DBNAME}" \
	--env METABASE_DB_PORT="${METABASE_DB_PORT}" \
	--env METABASE_DB_USER="${METABASE_DB_USER}" \
	--env METABASE_DB_PASS="${METABASE_DB_PASS}" \
	--env METABASE_DB_HOST="${METABASE_DB_HOST}" \
	--env METABASE_DB_FILE="${METABASE_DB_FILE}" \
	-m --pidfile $pidfile \
	--exec $command
}

stop() {
	start-stop-daemon --stop --pidfile $pidfile
}

depend() {
       need net
}
