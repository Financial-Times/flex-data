#!/usr/bin/env sh

set -a
set -x
set -e

: ${DB_HOST:localhost}
: ${MONGO_HOST:localhost}

: ${DB_MASTERUSERNAME:?}
: ${MONGO_MASTERUSERNAME:?}
: ${DB_MASTERPASSWORD:?}
: ${MONGO_MASTERPASSWORD:?}
: ${CLUSTER_ID:?}

: ${DB_PASSWORD:?}

cat > /tmp/batch.sql <<EOF
CREATE DATABASE IF NOT EXISTS ${CLUSTER_ID}_master ;
CREATE USER IF NOT EXISTS '${CLUSTER_ID}'@'%' IDENTIFIED BY '${DB_PASSWORD}' ;
GRANT TRIGGER on ${CLUSTER_ID}_master.* to '${CLUSTER_ID}'@'%' ;
GRANT ALL on ${CLUSTER_ID}_master.* to '${CLUSTER_ID}'@'%' ;

FLUSH PRIVILEGES ;
EOF

cat > /tmp/batch.js <<EOF
db.createUser({user:"${CLUSTER_ID}", pwd: "${DB_PASSWORD}", roles: [{role: "readWrite", db: "${CLUSTER_ID}"}] })
EOF

cat /tmp/batch.sql
cat /tmp/batch.js

mysql -h ${DB_HOST} -u ${DB_MASTERUSERNAME} -p${DB_MASTERPASSWORD} < /tmp/batch.sql
mongo ${MONGO_HOST}/${CLUSTER_ID} /tmp/batch.js
