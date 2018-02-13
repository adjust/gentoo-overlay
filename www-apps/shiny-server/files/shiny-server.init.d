#!/sbin/openrc-run

command="/opt/shiny-server/bin/shiny-server"
pidfile="/run/${SVCNAME}.pid"

depend(){
	use net
}

start() {
	ebegin "Starting Shiny Server Daemon"
	start-stop-daemon --start --quiet --background --exec "$command" \
		-m --pidfile "$pidfile" --user "shiny" --group "shiny"
	eend $?
}

stop() {
	ebegin "Stopping Shiny daemon"
	start-stop-daemon --quiet --stop --pidfile $pidfile
	eend $?
}
