@echo off

set CYGWIN=c:\cygwin\bin\
set WGET=wget
set JAR=http://www.electricjungle.ru:8080/files/universum.jar
set DIR=jungle.tmp
set CLIENTURL=JungleClusterSecretWord@www.electricjungle.ru:61000
set JAVA=c:\jdk1.6\bin\java
set MKDIR=%CYGWIN%\mkdir
set RM=%CYGWIN%\rm
set LANG=C

:START
 %RM% -rf %DIR%
 %MKDIR% -p %DIR%
 cd %DIR%
 %WGET%  %JAR%
 %JAVA%  -Xmx100M  -server -cp universum.jar universum.ClusterClient %CLIENTURL%
 sleep 15
 cd ..
 %RM% -rf %DIR%
 goto START

