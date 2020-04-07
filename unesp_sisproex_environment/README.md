# UNESP NDSI - SISPROEX Test Environment

How to use:
1) Install docker & docker-compose.
2) Download this folder at your local machine.
3) Edit config_server_xml.sh for your needs.
4) Edit docker-compose.yml for your needs (different names for example)
4) In the folder run the command:
- "docker-compose up -d"
5) Access the container with the command:
- "docker exec -it <container-name> bash"
6) Make sure to have a config.properties in your project for your container hostname
- "hostname -f"
7) Download and build your project:
- "svn_download_build.sh https://yoursvnhost.com/svn
- - If you save your password the first time, later you can just run "svn_download_build.sh last"
- - Although it's not recommended
8) Exit the container
- "exit"
9) Start tomcat from outside
- "docker exec <container-name> catalina.sh start"
