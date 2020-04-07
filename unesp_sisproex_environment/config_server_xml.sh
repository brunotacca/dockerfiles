########################################### 
#!/bin/bash 
# 
# Fast non interactively configuration 
#   of $CATALINA_HOME/conf/server.xml 
# 
# Author: Bruno Tacca
# Date: 2020-04-07
########################################### 

#name="jdbc/<USER_DATABASE>" 
#url="jdbc:postgresql://<HOST_IP>:5432/<DB_NAME>?autoReconnect=true" 
#username="<USER>"
#password="<PASSWORD>"

USER_DATABASE=youruserdbase
HOST_IP=yourhostip
DB_NAME=yourdbname
USER=youruser
PASSWORD=yourpasswrod

# Swap FOO for BAR in hello.txt
# sed 's/foo/bar/g' hello.txt
sed -i "s/<USER_DATABASE>/$USER_DATABASE/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<HOST_IP>/$HOST_IP/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<DB_NAME>/$DB_NAME/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<USER>/$USER/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<PASSWORD>/$PASSWORD/g" $CATALINA_HOME/conf/server.xml

#cat $CATALINA_HOME/conf/server.xml
