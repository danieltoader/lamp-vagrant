# LAMP for Vagrant
Complete Vagrant LAMP setup for development environment. Start developing in less than 5 minutes.
Development stack is based on Debian 9 (Stretch) with Apache 2.4, PHP 7.3 and MySQL 5.7. 
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
 * **Debian 9** (Stretch)
 * **Apache 2.4**
 * **MySQL 5.7**
 * **PHP 7.3**
 * Composer
 * Git
 * Curl
 
##### Included PHP packages
  * php7.3-intl 
  * php7.3-pdo 
  * php7.3-zip
  * php7.3-curl 
  * php7.3-mysql 
  * php7.3-mbstring 
  * php7.3-xml
  * php7.3-tokenizer 
  * php7.3-gd
  * php7.3-imagick
  * php7.3-dev 
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

Once the process is finished you can place your application in the ```www``` folder and access it using the ip 192.168.33.33.

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
 $ echo "\n192.168.33.33    lamp-vagrant.local" | sudo tee -a /etc/hosts
 ```

## Configuration

For fast configuration you can modify this variables in ```config.yml``` file.

```ỳaml
machine_name : &machine_name    'LAMP Vagrant'
local_domain : &local_domain    'lamp-vagrant.local'
private_ip   : &private_ip      '192.168.33.33'
machine_ram  : &machine_ram     'auto'
machine_cpu  : &machine_cpu     'auto'

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

## Others
##### Notice
You must understand that the VM is meant to be disposable, it is not supposed to be persistent. Any persistent data **should remain on your host computer**, do not apply changes to the VM nor store data or documents that you don't want to loose. 

As a consequence, you may mess up with the VM, do heavy testing, install new apps to evaluate them and even crash it. If you need to rollback, just destroy it and recreate it as pure as the driven snow but with all your data (sources, databases and configuration intact). It is as simple as a `vagrant destroy && vagrant up`.

##### Install latest vagrant on Linux (Ubuntu/Debian)
```bash
wget -c https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.deb
sudo dpkg -i vagrant_2.2.5_x86_64.deb
```
##### For ssh access type
```bash
vagrant ssh
```

Have Fun!