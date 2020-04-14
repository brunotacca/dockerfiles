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
- Access at localhost:8888 (or change the mapped port in docker-compose.yml)
5) Updating your project - manually 
- Access the container "docker exec -it {container-name} bash"
- Download and build your project "svn_download_build.sh https://yoursvnhost.com/svn
- - If you save your credentials the first time, later you can just run the alias "svn_download_build_java.sh last"
- - Although it's not recommended
6) Useful alias to create at your host machine:
- alias tt='docker logs -f {container-name}'
- alias build='docker exec -it {container-name} bash svn_download_build_java.sh last'
- alias dcbash='docker exec -it {container-name} bash'
- alias dcu="docker-compose up -d"
- alias dcs="docker-compose stop"
- alias dcd="docker-compose down"
- alias dcr="docker-compose restart"
7) If you want to do auto update an regularly: (Every 5 minutes for example)
- At your host machine, run "crontab -e"
- Add this line: 
- - */5 * * * * docker exec {container-name} bash svn_auto_update.sh
- Restart the cron service "service cron restart"
- Check if it's added with "crontab -l"