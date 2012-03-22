#!/bin/sh

mkdir -p $HOME/aws
cd $HOME/aws
curl --silent -o ec2-api-tools.zip http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
[ ! `type -p unzip` ] && sudo apt-get install -y unzip
unzip -q ec2-api-tools.zip
mkdir -p archive
mv ec2-api-tools.zip archive/
ln -s ec2-api-tools-* ec2
ls -l
echo "export EC2_HOME=\$HOME/aws/ec2
export PATH=$EC2_HOME/bin:\$PATH" > .env
[ ! `type -p java` ] && sudo apt-get install -y openjdk-6-jre-headless
java -version
# For Ubuntu 
echo "export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/" >> .env
# For Mac OSX Use
# export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
# For Redhat ??
. ./.env
ec2ver
