# UNESP NDSI - SISPROEX Test Environment

How to use:
1) Install docker & docker-compose.
2) Download and extract the necessary items at your local machine.
- wget https://github.com/brunotacca/dockerfiles/raw/master/unesp_sisproex_environment/unesp_sisproex_environment.tar
- tar xvf unesp_sisproex_environment.tar
- cd unesp_sisproex_environment
3) Edit docker-compose.yml for your needs.
4) Edit config_server_xml.sh for your needs.
5) Edit docker-compose.yml for your needs (different names for example)
6) Launch the container by typing:
- "docker-compose up -d"
7) Access the container with the command:
- "docker exec -it <container-name> bash"
8) Make sure to have a config.properties in your project for your container hostname
- "hostname -f"
9) Download and build your project:
- "svn_download_build.sh https://yoursvnhost.com/svn
- - If you save your password the first time, later you can just run "svn_download_build.sh last"
- - Although it's not recommended
10) Exit the container
- "exit"
11) Start tomcat from outside
- "docker exec <container-name> catalina.sh start"
12) Access at localhost:8888 (or change the mapped port in docker-compose.yml)