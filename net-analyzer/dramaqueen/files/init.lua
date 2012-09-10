#!/usr/bin/lua

-- user: the user dramaqueen will run as
-- dramaqueen will try to drop its priviledges as soon as possible
-- so you have to take care, that dramaqueen user has all needed rights
user = "dramaqueen"

-- group: the group dramaqueen will run as
-- dramaqueen will try to drop its priviledges as soon as possible
-- so you have to take care, that dramaqueen user has all needed rights
group = "dramaqueen"

-- sslCert: the openssl cert needed by the server
-- you will have to create that on your own
-- you will have to care to deploy it to all dramaqueen servers
sslCert = "/home/roa/programming/examples/ssl_conn/ssl_example/servercert.pem"

-- sslKey: the openssl key needed by the server
-- you will have to create that on your own
-- you will have to care to deploy it to all dramaqueen servers
sslKey = "/home/roa/programming/examples/ssl_conn/ssl_example/private.key"

-- xmpp: this flag indicates, whether you want to use the messageSystem as well
-- any not "1" value will be interpreted as false - even true
xmpp = "1"

-- xmppUser: the xmpp account the bot tries to log in
-- if xmpp is not set to 1, this value has no effect
xmppUser = "zabbix@localhost"

-- xmppPasswd: the xmpp passwd the bot will try to use to
-- log in the account specified in xmppUser
xmppPasswd = "test123"

-- bind: to address dramaqueen tries to bind to
-- it has to be formatted in this way:
-- "host:port"
bind = "localhost:9898"

-- daemonDir: the directory, where dramaqueen expects to find the
-- daemon config files
-- daemon config files must not start with a dot
-- daemon config files must end on ".lua" suffix
-- daemon config files must be executable for dramaqueen
daemonDir = "/var/lib/dramaqueen/daemon/"

-- scriptDir: the directory, where dramaqueen expects to find scripts
-- these scripts can be executed via the xmpp interface
-- these scripts can be executed via daemons
scriptDir = "/var/lib/dramaqueen/script/"

-- logDest: the file where logoutput go to
-- dramaqueen must have write access to this file
logDest  = "/var/log/dramaqueen/drama.log"

-- foreignHosts: hosts dramaqueen contacts to when a script is executed via xmpp interface
-- the script has to be in script directory on every host mentioned in foreignHosts
-- these hosts are not used for daemons, you specify them in the daemon config files
-- right now no authentification is implemented -> every user, who can contact dramaqueen can execute the scripts!
-- output goes always to the user who invoked the command
foreignHosts = { "localhost:9897", "localhost:9898", "playground.vm.over9000.org:9898" }
