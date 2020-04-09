########################################### 
#!/bin/bash 
# 
# - Checkout from a custom SVN.
# - Build Java Projects with ANT.
# - Move .war to tomcat webapps dir.
# 
# Author: Bruno Tacca
# Date: 2020-04-06
#
# Old version: 2013 by Andre Penteado / Felipe Gasparelo / Alessandro Moraes
########################################### 

# https://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html
# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html 

# Checking usage params
if [ "$#" -ne 1 ]
then 
   echo 
   echo "Usage: sh svn_download_build_java.sh <svn_server_root>" 
   echo "e.g.: https://yourhost.com/svn" 
   echo
   exit 0 
fi 

clear 

# Checking environment vars. -z > Empty
if [ -z "$JAVA_HOME" ]
then 
    echo "Need to set JAVA_HOME"
    exit 1
fi  
echo "Using JAVA_HOME: $JAVA_HOME"

if [ -z "$CATALINA_HOME" ]
then
    echo "Need to set CATALINA_HOME"
    exit 1
fi
echo "Using CATALINA_HOME: $CATALINA_HOME"

# Checking user and svn folder
USER_FOLDER=$HOME
SVN_FOLDER=$USER_FOLDER/svn
echo "SVN Folder: ${SVN_FOLDER}"

# Checking svn folder
if [ ! -d $SVN_FOLDER ] 
then
    echo "- SVN folder doesn't exists. Creating $SVN_FOLDER."
    mkdir -p ${SVN_FOLDER}
fi

if [ $1 != "last" ] 
then
    ###################################################################### 
    echo 
    echo "Download specific information:" 
    echo "------------------------------------" 
    echo 

    # Getting SVN_ROOT from param
    SVN_ROOT=$1
    echo $SVN_ROOT > ${SVN_FOLDER}/last_svn_root

    #############
    # Checking last svn user
    if [ ! -e $SVN_FOLDER/last_svn_user ] 
    then
        echo "" > ${SVN_FOLDER}/last_svn_user
    fi
    SVN_USER=$(cat $SVN_FOLDER/last_svn_user)
    echo -n "SVN User [ $SVN_USER ] > " 
    read NEW_SVN_USER 
    if [ -n "$NEW_SVN_USER" ] 
    then 
        SVN_USER="$NEW_SVN_USER" 
        echo $SVN_USER > ${SVN_FOLDER}/last_svn_user
    fi
    if [ -z "$SVN_USER" ]; then echo "User required."; exit 1; fi;

    #############
    # Checking last svn project
    if [ ! -e $SVN_FOLDER/last_svn_project ] 
    then
        echo "" > ${SVN_FOLDER}/last_svn_project
    fi
    SVN_MODULE=$(cat $SVN_FOLDER/last_svn_project)
    echo -n "SVN Project [ $SVN_MODULE ] > " 
    read NEW_SVN_MODULE 
    if [ -n "$NEW_SVN_MODULE" ] 
    then 
        SVN_MODULE="$NEW_SVN_MODULE" 
        echo $SVN_MODULE > ${SVN_FOLDER}/last_svn_project
    fi 
    if [ -z "$SVN_MODULE" ]; then echo "Project required."; exit 1; fi

    #############

    if [ ! -e $SVN_FOLDER/last_svn_branch ] 
    then
        echo "trunk" > ${SVN_FOLDER}/last_svn_branch
    fi
    SVN_BRANCH=$(cat $SVN_FOLDER/last_svn_branch)
    echo -n "SVN Branch [ $SVN_BRANCH ] > " 
    read NEW_SVN_BRANCH 
    if [ -n "$NEW_SVN_BRANCH" ] 
    then 
        SVN_BRANCH="$NEW_SVN_BRANCH" 
        echo $SVN_BRANCH > ${SVN_FOLDER}/last_svn_branch
    fi 
    if [ -z "$SVN_BRANCH" ]; then echo "Branch required."; exit 1; fi

    #############

    echo 
    echo "------------------------------------" 
    echo "Going to download as $SVN_USER from ${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH}" 
    echo "------------------------------------" 
    echo 
    echo -n "Type '1' to confirm: " 
    read confirmation 
    echo 
    if [ -e $confirmation ] || [ $confirmation != "1" ]; then exit 0; fi 

fi

SVN_PWLINE=""
if [ $1 == "last" ] && [ -e ${SVN_FOLDER}/last_svn_url ]
then
    SVN_USER=$(cat $SVN_FOLDER/last_svn_user)
    SVN_ROOT=$(cat $SVN_FOLDER/last_svn_root)
    SVN_MODULE=$(cat $SVN_FOLDER/last_svn_project)
    SVN_BRANCH=$(cat $SVN_FOLDER/last_svn_branch)
    echo 
    echo "------------------------------------" 
    echo "Going to download as $SVN_USER from ${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH}" 
    echo "------------------------------------" 
    echo 
    # Checking for auto password
    if [ -n "$SVN_PASSWORD" ]
    then 
        SVN_PWLINE="--non-interactive --trust-server-cert --password $SVN_PASSWORD"
    fi  

fi

###################################################################### 
 
# Backup actual project folder if exists
PROJECT_FOLDER=${SVN_FOLDER}/${SVN_MODULE}
DIR_BACKUP=$SVN_MODULE.old
if [ -d $PROJECT_FOLDER ] && [ ! -d "$SVN_FOLDER/$DIR_BACKUP" ]; then
	cp -r $PROJECT_FOLDER $SVN_FOLDER/$DIR_BACKUP
fi

###################################################################### 

echo 
echo "=====================================================================" 
echo "Downloading source from SVN Server. Write your password:"
echo "-----------------------------------------------------" 
echo 

SVN_URL=${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH}
echo $SVN_URL > ${SVN_FOLDER}/last_svn_url
if [ -d $PROJECT_FOLDER ]; then
    SVN_ACTUAL_URL=$(svn info ${PROJECT_FOLDER} | grep URL | sed "s/URL: //" | head -1)
    if [ $SVN_ACTUAL_URL = $SVN_URL ]; then
       svn update --username ${SVN_USER} ${SVN_PWLINE} ${PROJECT_FOLDER}
    else
       svn switch --username ${SVN_USER} ${SVN_PWLINE} $SVN_URL ${PROJECT_FOLDER}
    fi
else
    svn checkout --username ${SVN_USER} ${SVN_PWLINE} ${SVN_URL} ${PROJECT_FOLDER}
fi

if [ "$?" != "0" ]; then 
    echo 
    echo "-----------------------------------------------------" 
    echo "SVN Import failed. Installation aborted."
    echo 
    #rm -rf $SVN_MODULE 
    #mv $DIR_BACKUP $SVN_MODULE 
    exit 0 
fi 

#svn export --force ./svn/${SVN_MODULE} ./${SVN_MODULE}
rsync -a --delete -C ${PROJECT_FOLDER} ${USER_FOLDER}/

if [ "$?" != "0" ]; then 
    echo 
    echo "-----------------------------------------------------" 
    echo "SVN Export failed. Installation aborted."
    echo 
    #rm -rf $SVN_MODULE 
    #mv $DIR_BACKUP $SVN_MODULE 
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
