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
ln -sfn $CATALINA_HOME/ /usr/share/

# Logs dir
mkdir -p /SISTEMAS/logs
chmod 777 -R /SISTEMAS

# Aliases
touch $CATALINA_HOME/logs/catalina.out
echo "" >> ~/.bashrc
echo "alias tt='tail -f $CATALINA_HOME/logs/catalina.out'" >> ~/.bashrc
echo "alias build='svn_download_build_java last'" >> ~/.bashrc
echo "alias tstart='catalina.sh start'" >> ~/.bashrc
echo "alias tstop='catalina.sh stop'" >> ~/.bashrc
source ~/.bash_profile

# Keep the container running
catalina.sh start