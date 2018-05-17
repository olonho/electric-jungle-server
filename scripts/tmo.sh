#!/bin/sh

cmd=$1
tmo=$2

$cmd&
pid=$!
# be nice to others
renice 20 -p $pid 
wd="sleep $tmo; kill $pid 2>/dev/null; sleep 2; kill -9 $pid 2>/dev/null"
echo "Monitoring $pid($cmd)"
sh -c "$wd"&
killerpid=$!
wait $pid 2>/dev/null
kill $killerpid 2>/dev/null
