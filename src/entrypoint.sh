#!/usr/bin/env sh

set -a
set -x
set -e

: ${BUILDOUT:=install}

: ${DB_HOST:localhost}
: ${MONGO_HOST:localhost}

: ${DB_MASTERUSERNAME:?}
: ${MONGO_MASTERUSERNAME:?}
: ${DB_MASTERPASSWORD:?}
: ${MONGO_MASTERPASSWORD:?}
: ${CLUSTER_ID:?}

: ${DB_PASSWORD:?}

if [[ "${BUILDOUT}" = 'install']]; then
    cat > /tmp/batch.sql <<EOF
    CREATE DATABASE IF NOT EXISTS ${CLUSTER_ID}_master ;
    GRANT ALL on ${CLUSTER_ID}_master.* to '${CLUSTER_ID}'@'%' IDENTIFIED BY '${DB_PASSWORD}' ;
    GRANT TRIGGER on ${CLUSTER_ID}_master.* to '${CLUSTER_ID}'@'%' ;

    FLUSH PRIVILEGES ;
EOF
	cat > /tmp/batch.js <<EOF
	db.createUser({user:"${CLUSTER_ID}", pwd: "${DB_PASSWORD}", roles: [{role: "readWrite", db: "${CLUSTER_ID}"}] })
	sh.enableSharding("${CLUSTER_ID}")
EOF
elif [[ "${BUILDOUT}" = 'teardown']]; then
    cat > /tmp/batch.sql <<EOF
    DROP DATABASE IF EXISTS ${CLUSTER_ID}_master ;
    USE DATABASE mysql;
    DROP USER IF EXISTS '${CLUSTER_ID}' ;
EOF
    cat > /tmp/batch.js <<EOF
    db.dropDatabase()
EOF
fi

cat /tmp/batch.sql
cat /tmp/batch.js
mysql -h ${DB_HOST} -u ${DB_MASTERUSERNAME} -p${DB_MASTERPASSWORD} < /tmp/batch.sql
mongo ${MONGO_HOST}/${CLUSTER_ID} --username ${MONGO_MASTERUSERNAME} --password ${MONGO_MASTERPASSWORD} --authenticationDatabase admin /tmp/batch.js
