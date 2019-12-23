#!/bin/bash
sudo touch /tmp/install.log
sudo chmod 777 /tmp/install.log

echo $(date) >> /tmp/install.log
echo "-----------START-------------" >> /tmp/install.log

echo "-----------openjdk-8-jre-------------" >> /tmp/install.log
sudo apt-get update && sudo apt-get install openjdk-8-jre -y >> /tmp/install.log

echo "-----------jenkins-------------" >> /tmp/install.log
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - >> /tmp/install.log
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' >> /tmp/install.log
sudo apt-get update && sudo apt-get install jenkins -y >> /tmp/install.log

echo "-----------nginx-------------" >> /tmp/install.log
sudo apt-get -y install nginx >> /tmp/install.log

echo "-----------STEP#2-------------" >> /tmp/install.log
echo "-----------password-------------" >> /tmp/install.log
#.htpasswd, user: user01, password: user01
sudo echo 'user01:$apr1$.S4y9MKV$UTT43eHyJsnULFpGmFcq11' > /etc/nginx/.htpasswd

echo "-----------STEP#3-------------" >> /tmp/install.log
echo "-------config-nginx-------------" >> /tmp/install.log
sudo echo '' > /etc/nginx/sites-available/default
sudo echo ' server { ' > /etc/nginx/sites-available/default
sudo echo '       listen 80 default_server;' >> /etc/nginx/sites-available/default
sudo echo '       listen [::]:80 default_server;' >> /etc/nginx/sites-available/default
sudo echo '       root /var/www/html;' >> /etc/nginx/sites-available/default
sudo echo '       index index.html index.htm index.nginx-debian.html;' >> /etc/nginx/sites-available/default
sudo echo '       server_name _;' >> /etc/nginx/sites-available/default
sudo echo '       location / {' >> /etc/nginx/sites-available/default
sudo echo '				auth_basic "Access deny. Type your password";' >> /etc/nginx/sites-available/default
sudo echo '				auth_basic_user_file /etc/nginx/.htpasswd;' >> /etc/nginx/sites-available/default
sudo echo '				proxy_pass http://127.0.0.1:8080/;' >> /etc/nginx/sites-available/default
sudo echo '				proxy_set_header Authorization "";' >> /etc/nginx/sites-available/default
sudo echo '      }' >> /etc/nginx/sites-available/default
sudo echo '}' >> /etc/nginx/sites-available/default

sudo service nginx restart >> /tmp/install.log

echo "-----------END-------------" >> /tmp/install.log
echo $(date) >> /tmp/install.log
