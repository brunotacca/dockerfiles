########################################### 
#!/bin/bash 
# 
# - Make a checkout non-interactively
# - Based on svn_download_build_java.sh
#
# Author: Bruno Tacca
# Date: 2020-04-08
########################################### 

# Moved to env vars at docker-compose.yml
#SVN_ROOT='https://host.com/svn'
#SVN_MODULE='project'
#SVN_BRANCH='trunk'
#SVN_USER='userlogin'
#SVN_PASSWORD='userpassword'

# Checking environment vars. -z > Empty
if [ -z "$SVN_USER" ] && [ -z "$SVN_PASSWORD" ]
then 
    echo "Need to set SVN_USER & SVN_PASSWORD"
    exit 0
fi  

############################################

# Checking user and svn folder
USER_FOLDER=$HOME
SVN_FOLDER=$USER_FOLDER/svn
PROJECT_FOLDER=${SVN_FOLDER}/${SVN_MODULE}
echo "SVN Folder: ${SVN_FOLDER}"

# Checking svn folder
if [ ! -d $SVN_FOLDER ] 
then
    echo "- SVN folder doesn't exists. Creating $SVN_FOLDER."
    mkdir -p ${SVN_FOLDER}
fi

echo $SVN_ROOT > ${SVN_FOLDER}/last_svn_root
echo $SVN_MODULE > ${SVN_FOLDER}/last_svn_project
echo $SVN_BRANCH > ${SVN_FOLDER}/last_svn_branch
echo $SVN_USER > ${SVN_FOLDER}/last_svn_user

echo 
echo "==============================================================="
echo "Going to download as $SVN_USER from ${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH}" 
echo "==============================================================="
echo 

SVN_URL=${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH}
echo $SVN_URL > ${SVN_FOLDER}/last_svn_url
# Tip: pass '--no-auth-cache' if you don't want to save auth credentials.
svn checkout --non-interactive --trust-server-cert --username $SVN_USER --password $SVN_PASSWORD ${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH} ${PROJECT_FOLDER}

if [ "$?" != "0" ]; then 
    echo 
    echo "-----------------------------------------------------" 
    echo "SVN Import failed. Installation aborted."
    echo 
    exit 0 
fi 

rsync -a --delete -C ${PROJECT_FOLDER} ${USER_FOLDER}/

if [ "$?" != "0" ]; then 
    echo 
    echo "-----------------------------------------------------" 
    echo "SVN Export failed. Installation aborted."
    echo 
    exit 0 
fi

if [ -d ./${SVN_MODULE}/src ]; then
    svn --xml info ./svn/${SVN_MODULE} > ${USER_FOLDER}/${SVN_MODULE}/src/revision.xml
fi

##############################################################################

echo
echo "=====================================================================" 
echo "Building"
echo "----------"
echo

ant -f $(find $PROJECT_FOLDER/src -name build.xml)

if [ "$?" != "0" ]; then
    echo
    echo "====================================================================="
    echo
    echo "Build failed. Installation aborted."
    echo
    exit 0
fi

###################################################################### 

if [ "$(whoami)" != "root" ]
then
    echo 
    echo "=====================================================================" 
    echo 
    echo "Fixing permissions" 

    chown -R $(whoami) $PROJECT_FOLDER 
    chmod g+rx $PROJECT_FOLDER 
    chmod o+rx $PROJECT_FOLDER 
    chmod -R g+r $PROJECT_FOLDER/* 
    chmod -R o+r $PROJECT_FOLDER/* 
fi

###################################################################### 

echo
echo "==============================================================="
echo 
echo "GENERATING WAR"

cd $PROJECT_FOLDER/web
IDX='expr index $SVN_USER @ - 1'
BUILD_USER='expr substr $SVN_USER 1 $IDX'
NOW='date +"%d/%m %H:%M"'
BUILD="$SVN_BRANCH ($BUILD_USER - $NOW)"
echo $BUILD > last_ant_build
jar -cf ${USER_FOLDER}/$SVN_MODULE.war .
mv ${USER_FOLDER}/$SVN_MODULE.war $CATALINA_HOME/webapps/
cd ${USER_FOLDER}

###################################################################### 

echo 
echo "===============================================================" 
echo 
echo "DONE." 
echo
