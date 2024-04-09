#!/bin/bash

# Remove if not using fg %1
set -m

data_dir=./data
mysql='./bin/mysql -uroot'
mysql_admin=./bin/mysqladmin
mysql_data="${data_dir}/mysql-data"
mysqld="./bin/mysqld -uroot --datadir ${mysql_data}"
mysql_schema=./schema.sql

# create the data folder
if [[ ! -e "$data_dir" ]]; then
    mkdir $data_dir
fi

# create the MySQL data folder
create_db=false
if [[ ! -e "$mysql_data" ]]; then
    echo "create the MySQL data folder"
    create_db=true
    $mysqld --initialize-insecure
fi

# start the MySQL server
echo "start MySQL server"
$mysqld &


# wait until we get
echo "Wait for MySQL to start ..."
$mysql_admin status
mysql_status=$?
attempt=1
while [ $mysql_status -ne 0 -a $attempt -lt 16 ]; do
    echo " ... wait for MySQL to start (attempt $attempt of 15) ..."
    sleep 1
    $mysql_admin status
    mysql_status=$?
    attempt=$((attempt + 1))
done

if [ $mysql_status -ne 0 ]; then
    echo "could not start MySQL server"
    exit 1
fi
echo "MySQL up & running"

if [ $create_db = true ]; then
    echo "Creating the database..."
    $mysql < $mysql_schema
fi

# Brings back mysqld in the foreground
fg %1
