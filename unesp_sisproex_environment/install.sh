########################################### 
#!/bin/bash 
# 
# Run all custom shells
# 
# Author: Bruno Tacca
# Date: 2020-04-07
########################################### 

#sh ./script.sh

# Copy the svn build script to access globaly
cp /docker_sources/svn_download_build_java.sh /usr/local/bin
chmod +x /usr/local/bin/svn_download_build_java.sh

# Copy server.xml to tomcat folder
cp /docker_sources/server.xml $CATALINA_HOME/conf/
cat $CATALINA_HOME/conf/server.xml
# Edit the server.xml with your custom configurations
sh /docker_sources/config_server_xml.sh

# Simbolic link to tomcat at /usr/share (needed at sisproex build.xml)
ln -s $CATALINA_HOME/ /usr/share/

# Logs dir
mkdir -p /SISTEMAS/logs; \
chmod 777 -R /SISTEMAS; \

# Keep the container running 
tail -f /dev/null