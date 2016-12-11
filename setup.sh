#!/bin/bash

# System setup
sudo -H easy_install pip
sudo -H pip install virtualenv  # virtualenv to set up python environment
xcode-select --install  # update dev tools
# HOMEBREW ASSUMED INSTALLED /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install mysql  # mysql download

# Virtual environment setup
mkdir project
cd project
virtualenv -p /usr/bin/python2.7 venv
venv/bin/pip install flask
venv/bin/pip install flask-sqlalchemy
venv/bin/pip install flask-session
venv/bin/pip install Flask-OAuth
venv/bin/pip install passlib
venv/bin/pip install bcrypt
venv/bin/easy_install six
venv/bin/pip install mysql-python

# Set source to virtual environment
source venv/bin/activate

mysql.server start  # start server
mysql -u root < setup.sql  # create database

export FLASK_APP=ffserver.py
export FLASK_DEBUG=1
python ffserver.py

mysql.server stop  # stop server

deactivate  # end environment sourcing
