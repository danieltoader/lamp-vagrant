#!/usr/bin/env bash

# Default variable values
mysql_root_pass="root"
mysql_user="lamp"
mysql_user_pass="lamp"
mysql_user_db="lamp"

while getopts ":a:b:c:d:" opt; do
    case "${opt}" in
        a)
            mysql_root_pass="$OPTARG" ;;
        b)
            mysql_user="$OPTARG" ;;
        c)
            mysql_user_pass="$OPTARG" ;;
        d)
            mysql_user_db="$OPTARG" ;;
    esac
done

# Set timezone to your timezone
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Bucharest /etc/localtime

sudo apt-get update >> /vagrant/build.log 2>&1

echo "-- Installing debianconf --"
sudo apt-get install -y debconf-utils >> /vagrant/build.log 2>&1

echo "-- Installing dirmngr --"
sudo apt-get install dirmngr >> /vagrant/build.log 2>&1

echo "-- Installing unzip --"
sudo apt-get install -y unzip >> /vagrant/build.log 2>&1

echo "-- Installing aptitude --"
sudo apt-get -y install aptitude >> /vagrant/build.log 2>&1

echo "-- Updating package lists --"
sudo aptitude update -y >> /vagrant/build.log 2>&1

#echo "-- Updating system --"
#//sudo aptitude safe-upgrade -y >> /vagrant/build.log 2>&1

echo "-- Uncommenting alias for ll --"
sed -i "s/#alias ll='.*'/alias ll='ls -al'/g" /home/vagrant/.bashrc

echo "-- Installing curl --"
sudo aptitude install -y curl >> /vagrant/build.log 2>&1

echo "-- Installing apt-transport-https --"
sudo aptitude install -y apt-transport-https >> /vagrant/build.log 2>&1

echo "-- Adding GPG key for sury repo --"
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg >> /vagrant/build.log 2>&1

echo "-- Adding PHP 7 packages repo --"
echo 'deb https://packages.sury.org/php/ buster main' | sudo tee -a /etc/apt/sources.list >> /vagrant/build.log 2>&1

echo "-- Updating package lists again after adding sury --"
sudo aptitude update -y >> /vagrant/build.log 2>&1

echo "-- Installing Apache --"
sudo aptitude install -y apache2 >> /vagrant/build.log 2>&1

echo "-- Enabling mod rewrite --"
sudo a2enmod rewrite >> /vagrant/build.log 2>&1

echo "-- Configuring Apache --"
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo "-- Adding MySQL GPG key --"
wget -O /tmp/RPM-GPG-KEY-mysql https://repo.mysql.com/RPM-GPG-KEY-mysql >> /vagrant/build.log 2>&1
sudo apt-key add /tmp/RPM-GPG-KEY-mysql >> /vagrant/build.log 2>&1

echo "-- Adding MySQL repo --"
echo "deb http://repo.mysql.com/apt/debian/ buster mysql-5.7" | sudo tee /etc/apt/sources.list.d/mysql.list >> /vagrant/build.log 2>&1

echo "-- Updating package lists after adding MySQL repo --"
sudo aptitude update -y >> /vagrant/build.log 2>&1

# Set mysql paramaters for install
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password $mysql_root_pass"
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password $mysql_root_pass"

# Set phpmyadmin paramaters for install
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean false"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-user string root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password $mysql_root_pass'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password $mysql_root_pass'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password $mysql_root_pass'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/database-type select mysql'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/setup-password password $mysql_root_pass'
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/internal/skip-preseed boolean true"

echo "-- Installing MySQL server --"
sudo aptitude install -y mysql-server >> /vagrant/build.log 2>&1

echo "-- Creating alias for quick access to the MySQL (just type: db) --"
echo "alias db='mysql -u root -p$mysql_root_pass'" >> /home/vagrant/.bashrc

echo "-- Create mysql user and database --"
sudo mysql -u root -p$mysql_root_pass -e "CREATE DATABASE IF NOT EXISTS $mysql_user_db;" >> /vagrant/build.log 2>&1
sudo mysql -u root -p$mysql_root_pass -e "GRANT ALL PRIVILEGES ON $mysql_user_db.* TO '$mysql_user'@'%' IDENTIFIED BY '$mysql_user_pass';" >> /vagrant/build.log 2>&1
sudo mysql -u root -p$mysql_root_pass -e "FLUSH PRIVILEGES;" >> /vagrant/build.log 2>&1

echo "-- Installing PHP stuff --"
sudo aptitude install -y libapache2-mod-php7.4 php7.4 php7.4-dev php7.4-pdo php7.4-mysql php7.4-mbstring php7.4-xml php7.4-intl php7.4-tokenizer php7.4-gd php7.4-imagick php7.4-curl php7.4-zip >> /vagrant/build.log 2>&1

echo "-- Installing Xdebug --"
sudo aptitude install -y php-xdebug >> /vagrant/build.log 2>&1

echo "-- Configuring xDebug (idekey = PHP_STORM) --"
sudo tee -a /etc/php/7.4/mods-available/xdebug.ini << END
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9001
xdebug.idekey=PHP_STORM
END

echo "-- Custom configure for PHP --"
sudo tee -a /etc/php/7.4/mods-available/custom.ini << END
error_reporting = E_ALL
display_errors = on
END
sudo ln -s /etc/php/7.4/mods-available/custom.ini /etc/php/7.4/apache2/conf.d/00-custom.ini  >> /vagrant/build.log 2>&1

echo "-- Installing phpmyadmin --"
sudo aptitude install -q -y -f phpmyadmin >> /vagrant/build.log 2>&1
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf >> /vagrant/build.log 2>&1
sudo a2enconf phpmyadmin.conf >> /vagrant/build.log 2>&1

echo "-- Installing PHPUnit --"
sudo wget https://phar.phpunit.de/phpunit.phar
sudo chmod +x phpunit.phar
sudo mv phpunit.phar /usr/bin/phpunit

echo "-- Restarting Apache --"
sudo /etc/init.d/apache2 restart >> /vagrant/build.log 2>&1

echo "-- Installing Git --"
sudo aptitude install -y git >> /vagrant/build.log 2>&1

echo "-- Installing Composer --"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer >> /vagrant/build.log 2>&1
