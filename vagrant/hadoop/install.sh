#/usr/bin/env /bin/bash

YUM_QUIET="-q"


install_apache_product() {
  [ $# -ne 2 ] && echo "ERROR: Missing args" && return 1
  local PRODUCT="$1"
  local VERSION="$2"
  local TAR_FILE
  local EXTRA_DIR
  local CHECKSUM="md5"

  if [ -n $(type -P ${PRODUCT}) ]; then
    echo "'${PRODUCT}' appears installed" 
    if [ -f "/etc/profile.d/${PRODUCT}.sh" ]; then 
      source /etc/profile.d/${PRODUCT}.sh 
      return 0
    else
      echo "No /etc/profile.d found for '${PRODUCT}', re-installing"
    fi
  fi
  cd ${INSTALL_DIR}
  TAR_FILE="${PRODUCT}-${VERSION}.tar.gz"
  if [ ! -f "${TAR_FILE}" ]; then
    echo "Downloading ${TAR_FILE}..."
    if [ "${PRODUCT}" = "hadoop" ]; then
     EXTRA_DIR="common/"  # Hadoop has a subdirectory
     CHECKSUM="sha512" # Hadoop does not do md5
   fi
    curl -s -O -J https://mirrors.ocf.berkeley.edu/apache/${PRODUCT}/${EXTRA_DIR}${PRODUCT}-${VERSION}/${TAR_FILE}
    curl -s -O -J https://downloads.apache.org/${PRODUCT}/${EXTRA_DIR}${PRODUCT}-${VERSION}/${TAR_FILE}.${CHECKSUM}

    # Hack to fix full-path in hadoop checksum that causes error
    sed -i -e "s|/build/source/target/artifacts/||" ${TAR_FILE}.${CHECKSUM}
    ${CHECKSUM}sum -c ${TAR_FILE}.${CHECKSUM}
    [ $? -ne 0 ] && echo "ERROR: checksum failure" && exit 1
  fi 
  if [ ! -d "${PRODUCT}-${VERSION}" ]; then
    echo "Installing ${PRODUCT}-${VERSION}..."
    tar xfz ${TAR_FILE}
    rm -f ${PRODUCT}
    ln -s ${PRODUCT}-${VERSION} ${PRODUCT}
  fi
  echo "export PATH=${INSTALL_DIR}/${PRODUCT}/bin:\$PATH" >  /etc/profile.d/${PRODUCT}.sh
  source /etc/profile.d/${PRODUCT}.sh
  type -P ${PRODUCT}
  rm -f ${TAR_FILE}*
}

# Use TDD for verification of installation
[ -z "$(type -P bats)" ] && sudo yum install ${YUM_QUIET} -y http://rpmfind.net/linux/fedora/linux/releases/30/Everything/x86_64/os/Packages/b/bats-1.1.0-2.fc30.noarch.rpm
type -P bats
bats -version

# Install Java 11
[ -z "$(type -p java)" ] && sudo yum install ${YUM_QUIET} -y java-11-openjdk
java -version
type -P java
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.8.10-0.el7_8.x86_64" > /etc/profile.d/java.sh
source /etc/profile.d/java.sh

INSTALL_DIR="/usr/local" # Install globally
#INSTALL_DIR="${HOME}"   # Install locally

# Install Hadoop
install_apache_product hadoop 3.1.3
install_apache_product pig 0.17.0


# Verify Spot Check
type -P hadoop
type -P pig

hadoop -h help
pig -help
hadoop version
pig -version

# Run TDD tests
bats /vagrant/hadoop.bats
