########################################### 
#!/bin/bash 
# 
# Check the last revision number
# Update if it's different
# 
# Author: Bruno Tacca
# Date: 2020-04-09
#
########################################### 

# Checking environment vars. -z > Empty
if [ -z "$SVN_USER" ] && [ -z "$SVN_PASSWORD" ]
then 
    echo "Need to set SVN_USER & SVN_PASSWORD"
    exit 0
fi  

# Checking user and svn folder
USER_FOLDER=$HOME
SVN_FOLDER=$USER_FOLDER/svn
PROJECT_FOLDER=${SVN_FOLDER}/${SVN_MODULE}

# Checking svn folder
if [ ! -d $SVN_FOLDER ] 
then
    echo "Perform a checkout first."
    exit 0
fi


SVN_USER=$(cat $SVN_FOLDER/last_svn_user)
SVN_ROOT=$(cat $SVN_FOLDER/last_svn_root)
SVN_MODULE=$(cat $SVN_FOLDER/last_svn_project)
SVN_BRANCH=$(cat $SVN_FOLDER/last_svn_branch)

echo 
echo "==============================================================="
echo "Checking as $SVN_USER from ${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH}" 
echo "==============================================================="
echo 

SVN_URL=${SVN_ROOT}/${SVN_MODULE}/${SVN_BRANCH}
echo $SVN_URL > ${SVN_FOLDER}/last_svn_url
SVN_ACTUAL_URL=$(svn info ${PROJECT_FOLDER} | grep URL | sed "s/URL: //" | head -1)
if [ $SVN_ACTUAL_URL = $SVN_URL ]; then

    LOCAL_REVISION=$(svn info ${PROJECT_FOLDER} | grep Revision | sed "s/Revision: //" | head -1)
    echo "Local Revision: ${LOCAL_REVISION}"
    ACTUAL_REVISION=$(svn info ${SVN_URL} | grep Revision | sed "s/Revision: //" | head -1)
    echo "Actual Revision: ${ACTUAL_REVISION}"
    echo 

    echo "==============================================================="
    if [ $LOCAL_REVISION != $ACTUAL_REVISION ]; then
        echo "Performing update... Running svn_download_build_java.sh last"
        echo 
        sh svn_download_build_java.sh last
        #svn update --non-interactive --trust-server-cert --username ${SVN_USER} --password $SVN_PASSWORD ${PROJECT_FOLDER}
    else 
        echo "Nothing to do."
        echo 
    fi
    echo "==============================================================="

else 
    echo "URL Mismatch. Run svn_download_build_java to switch."
    echo "Actual URL: ${SVN_ACTUAL_URL}"
    exit 0
fi

