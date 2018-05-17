#!/bin/sh

HOST=`hostname`
ROOT=/net/electricjungle/ed
chmod +x $ROOT/ElectricJunglesServlet/scripts/cluster.sh
#exec $ROOT/ElectricJunglesServlet/scripts/cluster.sh 2>&1 > /dev/null
exec $ROOT/ElectricJunglesServlet/scripts/cluster.sh 2>&1 >> $ROOT/$HOST.log
