#!/bin/sh
#
# Sets a system up for a candlepin development environment (minus a db,
# handled separately), and an initial clone of candlepin.

set -e

export JAVA_VERSION=1.8.0
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION

# Install & configure dev environment
yum install -y epel-release

PACKAGES=(
    gcc
    gettext
    git
    hostname
    java-$JAVA_VERSION-openjdk-devel
    java-1.6.0-openjdk-devel
    java-1.7.0-openjdk-devel
    java-1.8.0-openjdk-devel
    libxml2-python
    liquibase
    mariadb
    mysql-connector-java
    openssl
    postgresql
    postgresql-jdbc
    python-pip
    rsyslog
    tig
    tmux
    qpid-proton-c-devel
    tomcat
    vim-enhanced
    wget
)

yum install -y ${PACKAGES[@]}

# Setup for autoconf:
mkdir /etc/candlepin
echo "# AUTOGENERATED" > /etc/candlepin/candlepin.conf

cat > /root/.bashrc <<BASHRC
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export HOME=/root
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION
BASHRC

# Create an initial candlepin checkout at /candlepin in image to help decrease
# the amount of time to run tests later on.
git clone https://github.com/candlepin/candlepin.git /candlepin
cd /candlepin

# Allow for grabbing specific pull requests
git config --add remote.origin.fetch "+refs/pull/*:refs/remotes/origin/pr/*"
git pull

# Setup and install rvm, ruby and pals
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh

rvm install 2.0.0
rvm use --default 2.0.0

# Install all ruby deps
gem install bundler
bundle install

# Installs all Java deps into the image, big time saver
# We run checkstyle explicitly here so it'll pull down its deps as well
buildr artifacts
buildr checkstyle || true
