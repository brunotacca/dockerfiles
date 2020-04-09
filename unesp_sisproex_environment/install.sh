#!/bin/bash 
########################################### 
# 
# Run all custom shells
# 
# Author: Bruno Tacca
# Date: 2020-04-07
########################################### 

#sh ./script.sh

# Copy the svn build scripts to access globaly
cp /docker_sources/svn_download_build_java.sh /usr/local/bin
chmod +x /usr/local/bin/svn_download_build_java.sh
cp /docker_sources/svn_auto_update.sh /usr/local/bin
chmod +x /usr/local/bin/svn_auto_update.sh

# Copy server.xml to tomcat folder
cp /docker_sources/server.xml $CATALINA_HOME/conf/
cat $CATALINA_HOME/conf/server.xml
# Edit the server.xml with your custom configurations
sh /docker_sources/config_server_xml.sh

# Simbolic link to tomcat at /usr/share (needed at sisproex build.xml)
ln -sfn $CATALINA_HOME/ /usr/share/

# Logs dir
mkdir -p /SISTEMAS/logs
chmod 777 -R /SISTEMAS

# Scheduling auto update
touch /etc/cron.d/cron_sisproex
chmod 777 /etc/cron.d/cron_sisproex
echo "*/5 * * * * sh /docker_sources/svn_auto_update.sh" >> /etc/cron.d/cron_sisproex
crontab /etc/cron.d/cron_sisproex

# Aliases
echo "" >> ~/.bashrc
echo "alias tt='tail -f $CATALINA_HOME/logs/catalina.out'" >> ~/.bashrc
echo "alias build='svn_download_build_java.sh last'" >> ~/.bashrc
echo "alias tstart='catalina.sh start'" >> ~/.bashrc
echo "alias tstop='catalina.sh stop'" >> ~/.bashrc
source ~/.bashrc

# First download & build from SVN (Configure the file with your credentials)
# Comment this if you want to do this manually
sh /docker_sources/svn_auto_checkout.sh

# Keep the container running
# tail -f /dev/null
catalina.sh run