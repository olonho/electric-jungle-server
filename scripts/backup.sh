#!/bin/sh

MYSQLDUMP=/opt/csw/mysql5/bin/mysqldump
TAG=`date +'%Y-%m-%d'`
ROOT=/export/ed/backup

$MYSQLDUMP -u root --password=Maugli --add-drop-table  --add-drop-database  ejungle | gzip  >  $ROOT/ejungle-$TAG.sql.gz
cp -r  /ed/tomcat/apache-tomcat-5.5.17/webapps/ejungle/beings/ $ROOT/beings-$TAG
