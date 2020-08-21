sudo apt update
sudo apt install apache2
sudo ufw app list
sudo ufw allow in "Apache Full"
http://your_server_ip
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
sudo apt install mysql-server
sudo mysql_secure_installation
sudo mysql
mysql> SELECT user,authentication_string,plugin,host FROM mysql.user;
mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
mysql> FLUSH PRIVILEGES;
mysql> SELECT user,authentication_string,plugin,host FROM mysql.user;
mysql> exit
sudo apt install php libapache2-mod-php php-mysql
sudo nano /etc/apache2/mods-enabled/dir.conf
### MOVE INDEX.PHP TO THE FIRST POSITION ###
sudo systemctl restart apache2
sudo systemctl status apache2


sudo nano /var/www/your_domain/info.php
### PASTE THE FOLLOWING ###
<?php
phpinfo();
?>

### VISIT http://your_domain/info.php ###
