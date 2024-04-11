#!/bin/bash

# data & resources
data_dir=/data
mkdir -p /data/repositories
mkdir -p /data/libraries
mkdir -p /data/tomcat/conf-ROOT
mkdir -p /data/tomcat/work-ROOT
mkdir -p /data/opensearch
chmod -R a+rwx /data
mysql_data="$data_dir/mysql"
mysql_schema=/opt/install/schema.sql

# MySQL commands
mysql_bin_dir=/opt/install/mysql/bin
mysql_cmd="$mysql_bin_dir/mysql -u root"
mysql_status_cmd="$mysql_bin_dir/mysqladmin -u root status"
mysqld_cmd="$mysql_bin_dir/mysqld -u root --datadir $mysql_data"

# initialize the database folder if it does not exist
create_db=false
if [[ ! -e "$mysql_data" ]]; then
    echo "create the MySQL data folder"
    create_db=true
    $mysqld_cmd --initialize-insecure
fi

# start the MySQL server
echo "start MySQL server"
$mysqld_cmd &

# wait until MySQL has started
$mysql_status_cmd
mysql_status=$?
attempt=1
while [ $mysql_status -ne 0 -a $attempt -lt 16 ]; do
    echo " ... wait for MySQL to start (attempt $attempt of 15) ..."
    sleep 1
    $mysql_status_cmd
    mysql_status=$?
    attempt=$((attempt + 1))
done
if [ $mysql_status -ne 0 ]; then
    echo "could not start MySQL server"
    exit 1
fi
echo "MySQL up & running"

# now we are sure that the MySQL server is running
# create the database if it does not exist
if [ $create_db = true ]; then
    echo "Creating the database..."
    $mysql_cmd < $mysql_schema
fi

# you can check if it was created, when you run the container
# in interactive mode and uncomment the command below; this
# will then open the mysql-repl:
# $mysql_cmd

echo "Start OpenSearch server ..."
chmod -R a+rwx /data/opensearch
sudo -H -u search_usr /opt/install/search/opensearch-tar-install.sh &
sleep 5

curl -I http://localhost:9200
search_status=$?
attempt=1
while [ $search_status -ne 0 -a $attempt -lt 16 ]; do
    echo " ... wait for OpenSearch to start (attempt $attempt of 15) ..."
    sleep 1
    curl -I http://localhost:9200
    search_status=$?
    attempt=$((attempt + 1))
done

if [ $search_status -ne 0 ]; then
    echo "OpenSearch server still not running; stop waiting"
else
    echo "OpenSearch up and running"
fi

catalina.sh run
