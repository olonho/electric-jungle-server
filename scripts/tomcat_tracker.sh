WGET=/opt/csw/bin/wget
JPS=/usr/java/bin/jps
JAVA_HOME=/usr/java
export JAVA_HOME

touch /tmp/watchcat.last
$WGET --no-proxy  --timeout=10 http://localhost:8080/main.jsp?page=intro -O /dev/null -o /dev/null && exit 0
echo Restarting
touch /tmp/watchcat.restart
/ed/tomcat/apache-tomcat-5.5.17/bin/shutdown.sh
$JPS | grep Bootstrap| awk '{ print $1 }'| xargs kill -9
#let it die
sleep 10
sh /ed/src/ElectricJunglesServlet/build/cata_g.sh >> /tmp/watchcat.log
