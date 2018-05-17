#!/bin/bash
PATH=/opt/csw/bin:/net/electricjungle/ed/ElectricJunglesServlet/scripts:/home/ni81036/bin:../ElectricJunglesServlet/scripts:/usr/java/bin:/usr/java/jdk1.6.0/bin:/usr/local/bin:$PATH:/usr/sfw/bin
export PATH

WGET=wget
JAR=http://www.electricjungle.ru:8080/files/universum.jar
DIR=/tmp/jungle$$
CLIENTURL=JungleClusterSecretWord@www.electricjungle.ru:61000
JAVA=java

#$JAVA -cp /net/electricjungle/ed/universum/bld/universum.jar universum.ClusterClient $CLIENTURL
#exit 0

while [ ! -f /net/electricjungle/ed/cluster/stopper ]; do
 rm -rf $DIR
 mkdir $DIR
 cd $DIR
 $WGET --no-cache $JAR
 tmo.sh "$JAVA -Xmx200M  -server -cp universum.jar universum.ClusterClient $CLIENTURL" 4000
 # wait a minute...
 sleep 60
 cd /tmp
 rm -rf $DIR
done
