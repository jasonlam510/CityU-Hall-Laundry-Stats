#!/bin/bash
set -e

# Read password from environment variable
GRAFANA_PASSWORD=${GRAFANA_MONGO_PASSWORD}

# Execute MongoDB commands to create the user
mongosh -u root -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin <<EOF
use admin
db.createUser({
  user: 'grafana',
  pwd: '${GRAFANA_PASSWORD}',
  roles: [
    {
      role: 'readAnyDatabase',
      db: 'admin'
    }
  ]
})
print('Grafana user created successfully with read access to any database');
EOF

