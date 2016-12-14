#!/bin/bash

# System setup
sudo easy_install pip
sudo pip install virtualenv  # virtualenv to set up python environment
sudo pip install bcrypt  # hashing algorithm that protects against rainbow/lookup tables
xcode-select --install  # update dev tools
# HOMEBREW ASSUMED INSTALLED /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install mysql  # mysql installation

# Virtual environment setup
mkdir project  # typical project setup for use of virtual environment
cd project     # however, venv could just be created in FindFolks directory
virtualenv -p /usr/bin/python2.7 venv  # creation of virtual environment using python 2.7
venv/bin/pip install flask  # install flask in virtual env
venv/bin/pip install flask-sqlalchemy  # install flask alchemy package
venv/bin/pip install flask-session  # install flask session package
venv/bin/pip install Flask-OAuth  # install flask oauth package
venv/bin/pip install passlib  # install passlib package
venv/bin/pip install bcrypt  # install in environment (Also needed system installation)
venv/bin/easy_install six  # flask/mysql-python requires six version > 1.4.1 which cannot be installed system wide
venv/bin/pip install mysql-python  # mysql-python installation
venv/bin/pip install requests  # requests package (needed for mailgun)

# Set source to virtual environment
source venv/bin/activate  # set python environment to virtual env
cd ..  # back to main directory

mysql.server start  # start server

mysql -u root < create.sql  # create database
                            # initially setup.sql intended to create and populate database
                            # but ffserver.py initializes tables and columns in db
export FLASK_APP=ffserver.py  # set flask target app
export FLASK_DEBUG=1  # set flask debugger
python ffserver.py  # run server to create db tables/columns
#  ^C (control-C) to exit
# mysql -u root < setup.sql  # populate database (theoretically) to populate db
# dependencies create format issues, info will be logged manually

# mysql.server stop  # stop server
#
# deactivate  # end environment sourcing
