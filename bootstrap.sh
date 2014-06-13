#!/usr/bin/env bash

# install requirements
sudo apt-get -y update
sudo apt-get -y install build-essential curl git-core\
  python-software-properties python g++ make libpcre3 libpcre3-dev

# install mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server libmysql-ruby libmysqlclient-dev
sudo service mysql restart

# install and setup nginx
sudo apt-get -y install nginx
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /vagrant/config/nginx.conf cubbyhole
sudo service nginx start

# install nodejs
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get -y update
sudo apt-get -y install nodejs

# install bower
sudo npm install bower -g

# install rvm
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
sudo usermod -a -G rvm vagrant

# install ruby
rvm install 2.0.0
rvm use 2.0.0 --default

# install imagemagick
sudo apt-get -y install imagemagick libmagickwand-dev

# install redis-server
sudo apt-get install redis-server

# setup rails app
gem install bundler
cd /vagrant
bundle
rake bower:install
rake db:create:all
rake db:migrate
rake db:migrate RAILS_ENV=test
rake db:seed
