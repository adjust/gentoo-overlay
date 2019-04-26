#!/bin/bash
# C 2018 Adjust
# license MIT

# don't fear
reaper()
{
	kill $!
	echo "Received SIGTERM/SIGINT"
	exit 0
}
trap reaper SIGINT SIGTERM

exit_error()
{
	echo "Error in env: ${1}"
	exit 2
}

# Environment to Java voodoo
# see /etc/conf.d/metabase
EXTRA_ARGS=""
[ -n "${METABASE_HEAP_OPTS}" ] && \
	EXTRA_ARGS="${METABASE_HEAP_OPTS}"

[ -n "${METABASE_LOG4J_FILE}" ] && \
	EXTRA_ARGS="-Dlog4j.configuration=file:${METABASE_LOG4J_FILE} $EXTRA_ARGS"

[ -n "${METABASE_PASSWORD_STRENGTH}" ] && \
	export MB_PASSWORD_STRENGTH="${METABASE_PASSWORD_STRENGTH}"

[ -n "${METABASE_PASSWORD_LENGTH}" ] && \
	export MB_PASSWORD_LENGTH="${METABASE_PASSWORD_LENGTH}"

if [ -n "${METABASE_ENCRYPTION_SECRET_KEY}" ]
then
	echo ${METABASE_ENCRYPTION_SECRET_KEY} | \
		base64 --decode &> /dev/null || \
		exit_error "\$METABASE_ENCRYPTION_SECRET_KEY is not base64"

	export MB_ENCRYPTION_SECRET_KEY="${METABASE_ENCRYPTION_SECRET_KEY}"
fi

if [ -n "${METABASE_DB_TYPE}" ] && [ "${METABASE_DB_TYPE}" != 'h2' ]
then
	export MB_DB_TYPE="${METABASE_DB_TYPE}"
	
	[ -n "${METABASE_DB_PORT}" ] && \
		export MB_DB_PORT="${METABASE_DB_PORT}" || \
		exit_error "${METABASE_DB_TYPE} but no port"

	[ -n "${METABASE_DB_USER}" ] && \
		export MB_DB_USER="${METABASE_DB_USER}" || \
		exit_error "${METABASE_DB_TYPE} but no user"

	[ -n "${METABASE_DB_PASS}" ] && \
		export MB_DB_PASS="${METABASE_DB_PASS}" || \
		exit_error "${METABASE_DB_TYPE} but no pass"

	[ -n "${METABASE_DB_HOST}" ] && \
		export MB_DB_HOST="${METABASE_DB_PASS}" || \
		exit_error "${METABASE_DB_TYPE} but no host"

elif [ -n "${METABASE_DB_TYPE}" ] && [ "${METABASE_DB_TPYE}" == 'h2' ]
then
	[ -n "${METABASE_DB_FILE}" ] && \
		export MB_DB_FILE="${METABASE_DB_FILE}" || \
		exit_error "${METABASE_DB_TYPE} but not file"
fi

if [ -n "${METABASE_BIND_ADDR}" ] && [ "${METABASE_SSL}" != 'true' ]
then
	export MB_JETTY_HOST="${METABASE_BIND_ADDR%:*}"
	export MB_JETTY_PORT="${METABASE_BIND_ADDR#*:}"

elif [ -n "${METABASE_BIND_ADDR}" ] && [ "${METABASE_SSL}" == 'true' ]
then
	export MB_JETTY_SSL="true"
	export MB_JETTY_HOST="${METABASE_BIND_ADDR%:*}"
	export MB_JETTY_SSL_Port="${METABASE_BIND_ADDR#*:}"
	export MB_JETTY_SSL_Keystore="${METABASE_SSL_KEYSTORE}"
	export MB_JETTY_SSL_Keystore_Password="${METABASE_SSL_KEYSTORE_PASSWORD}"
fi

# start the process and wait for the reaper
java $EXTRA_ARGS -jar /opt/metabase/bin/metabase-bin.jar &
wait -n $!

