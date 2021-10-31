# LAMP for Vagrant
Complete Vagrant LAMP setup for development environment. Start developing in less than 5 minutes.
Development stack is based on Debian 10 (Buster) with Apache 2.4, PHP 7.4 and MySQL 5.7. 
Composer is available for easy package management.

##### Table of Contents  
- [Prerequisites](https://github.com/danieltoader/lamp-vagrant#prerequisites)  
- [What is included?](https://github.com/danieltoader/lamp-vagrant#what-is-included)
- [Quick Start](https://github.com/danieltoader/lamp-vagrant#quick-start)
- [Configuration](https://github.com/danieltoader/lamp-vagrant#fast-configuration)
- [Others](https://github.com/danieltoader/lamp-vagrant#others)

## Prerequisites

You'll need to have the following prerequisites **installed** on your workstation:

 * [Git](http://git-scm.com/)
 * [VirtualBox](https://www.virtualbox.org/)
 * [Vagrant](http://www.vagrantup.com/)
 * Vagrant plugin [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) that automatically installs the host's VirtualBox Guest Additions on the guest system
    ```bash
    vagrant plugin install vagrant-vbguest
    ```

## What is included?
 * **Debian 10** (Buster)
 * **Apache 2.4**
 * **MySQL 5.7**
 * **PHP 7.4**
 * **PhpMyAdmin**
 * Composer
 * Git
 * Curl
 
##### Included PHP packages
  * php7.4-intl 
  * php7.4-pdo 
  * php7.4-zip
  * php7.4-curl 
  * php7.4-mysql 
  * php7.4-mbstring 
  * php7.4-xml
  * php7.4-tokenizer 
  * php7.4-gd
  * php7.4-imagick
  * php7.4-dev 
  * php-xdebug

## Quick Start

### Using the archive
Click the download button or this [link](https://github.com/danieltoader/lamp-vagrant/archive/master.zip) or use the script below.
Extract the files in the path that you will use for your project.
```bash
$ wget https://github.com/danieltoader/lamp-vagrant/archive/master.zip
$ unzip ./master.zip -d /path/to/project/root/directory
$ cd /path/to/project/root/directory
$ vagrant up
```

### Using git
```bash
$ git clone https://github.com/danieltoader/lamp-vagrant.git /path/to/project/root/directory
$ cd /path/to/project/root/directory
$ vagrant up
```

Once the process is finished you can place your application in the ```www``` folder and access it using the ip 192.168.90.10.

**Optional:**
You can access your application with an address name (http://vagrant.local) instead of an IP by adding the line below to your host file
```
192.168.90.10     lamp-vagrant.local
```
Hosts file path on:
* Windows: C:\windows\system32\drivers\etc\hosts
* Linux & MacOS: /etc/hosts
 
_Linux only_ use this command line to add the rule:

 ```bash
 $ echo "\n192.168.90.10    lamp-vagrant.local" | sudo tee -a /etc/hosts
 ```

## Configuration

To configure your VM, you need to create a ```config.yml``` file. 
You can use ```config-sample.yml``` as a template. For fast configuration you can rename the file to ```config.yml``` and change the variables in it.

```ỳaml
# Config virtual machine info
machine_name : 'LAMP Vagrant'
local_domain : 'lamp-vagrant.local'
private_ip   : '192.168.90.10'
machine_ram  : 'auto'
machine_cpu  : 'auto'

mysql_root_pass : 'root'
mysql_user      : 'lamp'
mysql_user_pass : 'lamp'
mysql_user_db   : 'lamp'

syncDir      :
    - host   : share
      guest  : /home/vagrant/share
    
    - host   : www
      guest  : /var/www/html
      owner  : vagrant
      group  : www-data
      dmode  : 775
      fmode  : 775
```
#### MySQL
A user and a database will be created from config.yaml (mysql_user, mysql_user_pass, mysql_user_db), the user will have all privileges on the defined database

#### PhpMyAdmin
To connect to PhpMyAdmin access `{private_ip}/phpmyadmin` and use the mysql_user and mysql_user_pass to log in.

## Others
##### Notice
You must understand that the VM is meant to be disposable, it is not supposed to be persistent. Any persistent data **should remain on your host computer**, do not apply changes to the VM nor store data or documents that you don't want to lose. 

As a consequence, you may mess up with the VM, do heavy testing, install new apps to evaluate them and even crash it. If you need to rollback, just destroy it and recreate it as pure as the driven snow but with all your data (sources, databases and configuration intact). It is as simple as a `vagrant destroy && vagrant up`.

##### Install latest vagrant on Linux (Ubuntu/Debian)
```bash
wget -c https://releases.hashicorp.com/vagrant/2.2.18/vagrant_2.2.18_x86_64.deb
sudo dpkg -i vagrant_2.2.18_x86_64.deb
```
##### For ssh access type
```bash
vagrant ssh
```

Have Fun!