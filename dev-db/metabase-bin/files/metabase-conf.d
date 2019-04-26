## passed to Java as args
#METABASE_HEAP_OPTS=""
#METABASE_LOG4J_FILE="/opt/metabase/lib/log4j.properties"

## metabase opts, passed to metabase as env
##METABASE_PASSWORD_COMPLEXITY=strong,normal,weak
METABASE_PASSWORD_COMPLEXITY=strong
METABASE_PASSWORD_LENGTH=10

##METABASE_ENCRYPTION_SECRET_KEY=$(openssl rand -base64 32)
#METABASE_ENCRYPTION_SECRET_KEY=""

##metabase DB connection, in case h2 will not do
#METABASE_DB_TYPE=postgres
#METABASE_DB_DBNAME=metabase
#METABASE_DB_PORT=5432
#METABASE_DB_USER=""
#METABASE_DB_PASS=""
#METABASE_DB_HOST="localhost"
##only relevant if TYPE is h2
#METABASE_DB_FILE="/opt/metabase/lib/metabase.db.mv.db"

## passed to java/jetty as env
#METABASE_BIND_ADDR="0.0.0.0:6000"
#METABASE_SSL="true"
#METABASE_SSL_KEYSTORE=""
#METABASE_SSL_KEYSTORE_PASSWORD=""
