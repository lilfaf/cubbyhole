#!/usr/bin/env bash

# install requirements
sudo apt-get -y update
sudo apt-get -y install build-essential curl git-core\
  python-software-properties python g++ make libpcre3 libpcre3-dev

# install postresql / nodejs
sudo add-apt-repository ppa:chris-lea/node.js
sudo add-apt-repository ppa:chris-lea/postgresql-9.3

sudo apt-get -y update
sudo apt-get -y install libpq-dev postgresql-9.3 postgresql-contrib-9.3 nodejs

# compile nginx with file upload module
wget http://nginx.org/download/nginx-1.4.7.tar.gz
tar xvzf nginx-1.4.7.tar.gz
cd nginx-1.4.7
make && make install
cd ..

# setup nginx
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /vagrant/config/nginx.conf cubbyhole
sudo service nginx start

# fix locals
echo "export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8" >> /etc/bash.bashrc

# setup postgresql
echo "
UPDATE pg_database SET datistemplate=false WHERE datname='template1';
DROP DATABASE Template1;
CREATE DATABASE template1 WITH owner=postgres encoding='UTF-8' lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;
UPDATE pg_database SET datistemplate=true WHERE datname='template1';
" | sudo tee -a sql.sql

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
sudo -u postgres psql -f sql.sql
sudo rm sql.sql

# install rvm
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
sudo usermod -a -G rvm vagrant

# install ruby
rvm install 2.0.0
rvm use 2.0.0 --default

# setup rails app
gem install bundler
cd /vagrant
bundle
rake db:create:all
rake db:migrate
rake db:migrate RAILS_ENV=test
rake db:seed
