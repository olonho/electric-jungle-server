DEPLOYHOST=localhost
DBPASS="Maugli"
HTTPPASS="DeepForest"
SYNC_FILE=/ed/src/ejungle.sql
A=@
PLATFORM=$(shell uname)
PLATFORM := $(subst CYGWIN,Windows,$(PLATFORM))
ifeq ($(findstring Windows, $(PLATFORM)),)
 SEP=:
else
 SEP=\;
endif

ifeq ($(findstring SunOS, $(PLATFORM)),)
 TOOLS=/opt/csw/bin/
else
 TOOLS=
endif
STATIC_HTTP_ROOT=/opt/csw/apache2/share/htdocs
#STATIC_HTTP_ROOT=/var/apache/htdocs/

WGET=$(TOOLS)wget
RSYNC=$(TOOLS)rsync

TARGET_DIR=/ed/tomcat/apache-tomcat-5.5.17/webapps/ejungle
DIST=../dist
WWW_ROOT=../src/wwwroot
CLASSES_ROOT=../src/classes
CLASSES_JAR=$(DIST)/ejungle.jar
DEPLOY_ROOT=../deploy
LIBS=../libs/servlet-api.jar$(SEP)../libs/mysql-connector.jar$(SEP)../libs/commons-fileupload.jar

JAVA_SRC=$(shell      \
           find       \
              $(CLASSES_ROOT)  \
             -name CVS -prune -o \
             -name '*.java' -print \
           )

all: sanity prepare $(CLASSES_JAR)

run: all
	$(JAVA_HOME)/bin/java -server -classpath $(LIBS)$(SEP)$(DIST)/classes \
               ejungle.manager.Manager

sanity:
	$(A)if [ ! -d $(JAVA_HOME)/jre ]; then \
          echo "Please set JAVA_HOME to 1.5 JDK, use forward slashes on Win32";\
          exit 1; \
        fi

prepare:
	$(A)mkdir -p $(DIST)/classes

classes: $(JAVA_SRC)
	$(A)echo "Getting security manager..."
	$(A)mkdir -p $(DIST)/classes/universum/engine
	$(A)cp -f ../../universum/dist/universum/engine/JungleSecurity.class \
                  $(DIST)/classes/universum/engine
	$(A)if [ -f ../../universum/bld/universum.jar ]; then \
              echo "Getting engine...";                       \
              cp -f ../../universum/bld/universum.jar         \
                    $(WWW_ROOT)/files/universum.jar;          \
	    fi
	$(A)if [ -f ../../universum/bld/distr.jar ]; then     \
	      echo "Getting distribution...";                 \
              cp -f ../../universum/bld/distr.jar             \
                    $(WWW_ROOT)/files/ejungle_distr.jar;      \
	    fi
	$(A)if [ -d ../../universum/docs ]; then              \
	      echo "Syncing docs...";                         \
	      cp -rf ../../universum/docs $(WWW_ROOT)/files/;  \
	    fi
	$(A)echo "Compiling Java classes..."
	$(JAVA_HOME)/bin/javac -source 1.5 \
          -classpath $(LIBS)$(SEP)$(DIST)/classes -d $(DIST)/classes $(JAVA_SRC)

$(CLASSES_JAR): classes
	$(A)echo "Remaking $@..."
	$(A)mkdir -p $(DIST)/classes/universum/engine
	$(A)cp -f ../../universum/dist/universum/engine/JungleSecurity.class $(DIST)/classes/universum/engine
	$(A)$(JAVA_HOME)/bin/native2ascii -encoding  cp1251 ../src/resources/strings_ru.properties  $(DIST)/classes/strings_ru.properties
	$(A)$(JAVA_HOME)/bin/native2ascii ../src/resources/strings_en.properties  $(DIST)/classes/strings_en.properties
	$(A)$(JAVA_HOME)/bin/jar -cf $(CLASSES_JAR) -C $(DIST)/classes .

install: $(CLASSES_JAR)
	$(A)echo "Updating server directory..."
	$(A)-$(RSYNC) -avz --exclude=CVS $(WWW_ROOT)/* "$(TARGET_DIR)/"
	$(A)-chmod -R a+r "$(TARGET_DIR)/"
	$(A)-chmod a+rw "$(TARGET_DIR)/beings"
	$(A)mkdir -p "$(TARGET_DIR)/WEB-INF/lib"
	$(A)cp -f $(CLASSES_JAR) "$(TARGET_DIR)/WEB-INF/lib/"
	$(A)mkdir -p "$(TARGET_DIR)/WEB-INF/tags"
	$(A)cp -f $(DEPLOY_ROOT)/tags/*.tag "$(TARGET_DIR)/WEB-INF/tags/"
	$(A)cp -f $(DEPLOY_ROOT)/lib/*.jar "$(TARGET_DIR)/WEB-INF/lib/"
	$(A)-cp -f ../../universum/bld/universum.jar  "$(TARGET_DIR)/files/"
	$(A)-$(WGET) --http-user=admin --http-password=$(HTTPPASS) --no-proxy --spider \
	  http://$(DEPLOYHOST):8080/manager/html/reload?path=/ -O web.log

reload:
	$(A)$(WGET) --http-user=admin --http-password=$(HTTPPASS) --no-proxy --spider \
	  http://$(DEPLOYHOST):8080/manager/html/reload?path=/ -O web.log

clean:
	$(A)rm -rf $(DIST)/* $(CLASSES_JAR) web.log

dump:
	$(A)echo "Dumping DB to $(SYNC_FILE)"
	$(A)/opt/csw/mysql5/bin/mysqldump -u root --password=$(DBPASS) --add-drop-table  --add-drop-database  ejungle >  $(SYNC_FILE)

restore:
	$(A)echo "Restoring DB from $(SYNC_FILE)"
	$(A)/opt/csw/mysql5/bin/mysql -u root --password=$(DBPASS) ejungle < $(SYNC_FILE)


static_server:
	rm -rf mirror
	mkdir mirror
	cd mirror && $(WGET) --no-proxy -r http://localhost:8080/ejungle/
	perl ../scripts/patcher.pl ./mirror
	rm -rf $(STATIC_HTTP_ROOT)/ejungle
	mv mirror/localhost\:8080/ejungle $(STATIC_HTTP_ROOT)/ejungle
