# UNESP NDSI - SISPROEX Test Environment

How to use:
1) Install docker & docker-compose.
2) Download and extract the necessary items at your local machine.
- wget https://github.com/brunotacca/dockerfiles/raw/master/unesp_sisproex_environment/unesp_sisproex_environment.tar
- tar xvf unesp_sisproex_environment.tar
- cd unesp_sisproex_environment
3) Edit docker-compose.yml for your needs 
- Change the container name and hostname
- Make sure to have a config.properties in your project for your container hostname
- Choose your mapped port
- Change the catalina memory configuration to fit your VM (CATALINA_OPTS)
- Enter your project database connection info
- Enter your project svn connection info (for auto download & build)
- - Remove SVN_PASSWORD and credentials if you don't want the auto build.
4) Launch the container by typing:
- "docker-compose up -d"
5) Access tomcat logs by typing:
- "docker logs -t -f {container-name}"
6) Updating your project - manually 
- Access the container "docker exec -it {container-name} bash"
- Download and build your project "svn_download_build.sh https://yoursvnhost.com/svn
- - If you save your credentials the first time, later you can just run the alias "build"
- - Although it's not recommended
7) Updating your project - automatically
- docker exec {container-name} build
8) Access at localhost:8888 (or change the mapped port in docker-compose.yml)