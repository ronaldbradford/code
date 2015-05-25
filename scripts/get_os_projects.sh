#!/bin/sh

#  Script:      get_os_project.sh
#  Description: Get the current code of OpenStack projects
#  Author:      Ronald Bradford


# Default Global Variables
[ -z "${TMP_DIR}" ] && TMP_DIR="/tmp"
[ -z "${BASE_DIR}" ] && BASE_DIR="${HOME}"
GIT_BASE="git://git.openstack.org"
PROJECT_LIST_URL="http://git.openstack.org/cgit/openstack-infra/project-config/plain/gerrit/projects.yaml"


# Get current Project List
PROJECT_LIST="${TMP_DIR}/project.yaml"
curl -sL ${PROJECT_LIST_URL} > ${PROJECT_LIST}

# Determine which subset of projects to get
[ -z "${PROJECT_BASE}" ] && PROJECT_BASE="openstack/"

for PROJECT in `grep "^- project: ${PROJECT_BASE}" ${PROJECT_LIST} | cut -d: -f2`
do
  echo ${PROJECT}
  PROJECT_CLASS=`dirname ${PROJECT}`
  cd ${BASE_DIR}
  if [ -d "${PROJECT}" ]
  then
    cd ${PROJECT}
    git pull
  else
    mkdir -p ${PROJECT_CLASS}
    cd ${PROJECT_CLASS}
    git clone ${GIT_BASE}/${PROJECT}
  fi
done

exit 0
