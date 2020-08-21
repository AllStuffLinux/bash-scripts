#!/bin/bash


# configure
tld="localhost"
mysqlconfig="$HOME/.my.cnf"
dbhost="localhost"
wpcliyml="$HOME/.bin/wp-cli.yml"


# check for existing wordpress install
if [ -f "wp-config.php" ]; then
	echo "WordPress is already installed here. Exiting."
	exit
fi


# check if the wp command is available
if ! hash wp 2>/dev/null; then
	echo "ERROR: wp command not found"
	exit
fi


# check if wp-cli.yml exists
if [ ! -f $wpcliyml ]; then
	echo "The wp-cli.yml file does not exist. Exiting."
	exit
fi


# parse command-line options
while :; do
	case "$1" in
		-b|--beta)
			beta="true"
			;;
		-h|--help)
			echo "Memorable Usage: $0 [ --beta | --help ]"
			echo "Shorthand Usage: $0 [ -b | -h ]"
			exit 1
			;;
		*) # Default case: If no more options then break out of the loop.
			break
	esac
	shift
done

# catch user input
 
curdir=${PWD##*/}
site_url="http://$curdir.$tld"
echo $site_url
 
echo -n "Enter the site title and press [ENTER]: "
read site_title
echo $site_title
 
read -p "WordPress Version [latest]: " wpversion
wpversion=${wpversion:-latest}
echo $wpversion
 
read -p "Database name [$curdir]: " dbname
dbname=${dbname:-$curdir}
echo $dbname
 
read -p "Database username [root]: " dbuser
dbuser=${dbuser:-root}
echo $dbuser
 
read -p "Database prefix [wp_]: " dbprefix
dbprefix=${dbprefix:-wp_}
echo $dbprefix
 
read -p "WordPress admin username [neo]: " admin_user
admin_user=${admin_user:-neo}
echo $admin_user
 
read -p "WordPress admin password [matrix]: " admin_pass
admin_pass=${admin_pass:-matrix}
echo $admin_pass
 
read -p "WordPress admin email [webmaster@localhost]: " admin_email
admin_email=${admin_email:-webmaster@localhost}
echo $admin_email

# copy over the wp-cli.yml file
cp $wpcliyml .


# if no mysqlconfig exists, exit with error
if [ ! -f $mysqlconfig ]; then
	echo "ERROR: mysql config (.my.cnf) does not exist"
	exit
fi
 
# get root password from mysql config
dbpass_tmp=`awk "/client$dbuser/{getline; print}" $mysqlconfig`
if [[ $dbpass_tmp == *"\""* ]]; then
	dbpass=`echo $dbpass_tmp | cut -d '"' -f2`
fi
if [[ $dbpass_tmp == *"'"* ]]; then
	dbpass=`echo $dbpass_tmp | cut -d "'" -f2`
fi
 
# check if password variable has a value
if [ -z $dbpass ]; then
	# if not, print error and exit
	echo "ERROR: no database password"
	exit
fi

# INSTALL WORDPRESS
 
# download wordpress core
if [ $wpversion == "latest" ]; then
	wp core download --path=.
else
	wp core download --path=.  --version=$wpversion
fi
 
# configure wordpress core
wp core config --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" --dbhost="$dbhost" --dbprefix="$dbprefix" --extra-php <

# remove default plugins
echo "Removing default plugins..."
rm -rf ./wp-content/plugins/*

# set rewrites structure and flush rewrites
wp rewrite structure '/%postname%/'
wp rewrite flush --hard

echo "Installed WordPress."


[clientroot]
  password="passwordgoeshere"


apache_modules:
  - mod_rewrite
