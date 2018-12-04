#!/usr/bin/env bash

apt-get update
apt-get install -y python-pip \
                   python3-pip \
                   supervisor \
                   nginx

APP_NAME="randomly"
APP_DIR="/srv/app/$APP_NAME"
GIT_REPO="https://github.com/djungyvr/randomly.git"

# Create locations this app will write to and live in
# Create logging directory
mkdir -p /var/log/randomly

# Create the application directory
mkdir -p /srv/app
cd /srv/app

# Whether we are working in a vagrant box or production box
if [ "$RANDOMLY_ENV" = "prod" ]; then
    # Clones the project from master
    git clone $GIT_REPO
else
    ln -f -s /vagrant $APP_DIR
fi

cd $APP_DIR

# Setup the virtualenv
pip3 install virtualenv
virtualenv --no-site-packages -p python3 venv
source venv/bin/activate
pip3 install -r requirements.txt

# Link the supervisord conf
ln -r -f -s $APP_DIR/bootstrap/supervisord.conf /etc/supervisor/conf.d/$APP_NAME.conf

# Nginx setup
rm -f /etc/nginx/sites-enabled/default

# Link the Nginx configs
ln -r -f -s $APP_DIR/bootstrap/nginx /etc/nginx/sites-available/$APP_NAME
ln -f -s /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/$APP_NAME

# Add a user to run this app as
useradd $APP_NAME
chown $APP_NAME:$APP_NAME /var/log/$APP_NAME
chown $APP_NAME:$APP_NAME /srv/app/$APP_NAME

# Restart services
service supervisor restart
nginx -s reload
