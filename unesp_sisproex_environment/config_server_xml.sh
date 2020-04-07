########################################### 
#!/bin/bash 
# 
# Fast non interactively configuration 
#   of $CATALINA_HOME/conf/server.xml 
# 
# Author: Bruno Tacca
# Date: 2020-04-07
########################################### 

# server.xml contains the following connection line:
#   name="<RESOURCE_NAME>" 
#   url="jdbc:postgresql://<HOST_IP>:<HOST_PORT>/<DB_NAME>?<CONNECTION_PARAMS>" 
#   username="<USER>"
#   password="<PASSWORD>"

RESOURCE_NAME='yourresourcename'
HOST_IP='yourhostip'
HOST_PORT='5432'
DB_NAME='yourdbname'
CONNECTION_PARAMS='autoReconnect=true'
USER='youruser'
PASSWORD='yourpasswrod'

sed -i "s/<RESOURCE_NAME>/$RESOURCE_NAME/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<HOST_IP>/$HOST_IP/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<HOST_PORT>/$HOST_PORT/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<DB_NAME>/$DB_NAME/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<CONNECTION_PARAMS>/$CONNECTION_PARAMS/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<USER>/$USER/g" $CATALINA_HOME/conf/server.xml
sed -i "s/<PASSWORD>/$PASSWORD/g" $CATALINA_HOME/conf/server.xml

