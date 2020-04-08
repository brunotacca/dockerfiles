# UNESP NDSI - SISPROEX Test Environment

How to use:
1) Install docker & docker-compose.
2) Download and extract the necessary items at your local machine.
- wget https://github.com/brunotacca/dockerfiles/raw/master/unesp_sisproex_environment/unesp_sisproex_environment.tar
- tar xvf unesp_sisproex_environment.tar
- cd unesp_sisproex_environment
3) Edit config_server_xml.sh for your needs (database connection).
4) AutoCheckout (svn_auto_checkout.sh):
- If you don't want an auto checkout at first run, comment the script execution at install.sh
- If you want the auto checkout, configure your credentials in svn_auto_checkout.sh
5) Edit docker-compose.yml for your needs (different names for example)
- Make sure to have a config.properties in your project for your container hostname
6) Launch the container by typing:
- "docker-compose up -d"
- To destroy the container: "docker-compose down"
7) Access tomcat logs by typing:
- "docker logs -t -f <container-name>"
8) Updating your project - manually 
- Access the container "docker exec -it <container-name> bash"
- Download and build your project "svn_download_build.sh https://yoursvnhost.com/svn
- - If you save your credentials the first time, later you can just run the alias "build"
- - Although it's not recommended
9) Updating your project - automatically
- docker exec <container-name> build
10) Access at localhost:8888 (or change the mapped port in docker-compose.yml)