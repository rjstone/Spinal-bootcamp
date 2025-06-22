#!/bin/sh

ADOPTIUM_KEYID=843C48A565F8F04B

apt-get install -y wget apt-transport-https gpg
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${ADOPTIUM_KEYID}
gpg --export --armor ${ADOPTIUM_KEYID} > /etc/apt/trusted.gpg.d/adoptium.asc
apt-get update
apt-get install -y temurin-${JAVA_JDK_VERSION}-jdk
update-java-alternatives -l
update-java-alternatives --set /usr/lib/jvm/temurin-21-jdk-amd64
java -version
apt-get -y dist-clean