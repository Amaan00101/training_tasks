#!/bin/bash

BACKUP_DIR=/var/backups/mysql
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="${BACKUP_DIR}/mysql_backup_${DATE}.sql"

mysqldump -u amaan -p${new_pass} ${dbname} > ${BACKUP_FILE}
gzip ${BACKUP_FILE}