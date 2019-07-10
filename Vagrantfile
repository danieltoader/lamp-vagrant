# -*- mode: ruby -*-
# vi: set ft=ruby :

# Require YAML module
require 'yaml'

# Get dir path
dir = File.dirname(File.expand_path(__FILE__))
# Read YAML files
configs = YAML.load_file("#{dir}/config.yaml")

# Vagrantfile API/syntax version.
# Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |srv|
    srv.vm.box = "debian/stretch64"
	srv.vm.hostname = configs['local_domain']

    if Vagrant.has_plugin? 'vagrant-vbguest'
        # All good
    else
        raise Vagrant::Errors::VagrantError.new,
            "vagrant-vbguest missing, please install the plugin:\n" +
            "vagrant plugin install vagrant-vbguest"
    end

	# Network
	# Create a private network, which allows host-only access to the machine using a specific IP.
	srv.vm.network "private_network", ip: configs['private_ip']
	# srv.vm.network "public_network"

    # Forward http port on 8080, used for connecting web browsers to localhost:8080
    # srv.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine.
    # Forward MySql port on 33066, used for connecting admin-clients to localhost:33066
    # srv.vm.network "forwarded_port", guest: 3306, host: 8081

    # Shared folder
    # Set share folder permissions to 777 so that apache can write files

    if configs["syncDir"]
        configs['syncDir'].each do |syncDir|
            if syncDir["owner"] && syncDir["group"]
                srv.vm.synced_folder syncDir["host"],
                syncDir["guest"],
                owner: "#{syncDir["owner"]}",
                group: "#{syncDir["group"]}",
                mount_options:["dmode=#{syncDir["dmode"]}",
                "fmode=#{syncDir["fmode"]}"],
                create: true
            else
                srv.vm.synced_folder syncDir['host'],
                syncDir['guest'],
                create: true
            end
        end
    else
        raise Vagrant::Errors::VagrantError.new,
            "At least one synced_folder must be defined. Use default if you do not need something special"
    end

    # Virtual box settings
    # Provider-specific configuration so you can fine-tune VirtualBox for Vagrant.
    # These expose provider-specific options.
    srv.vm.provider "virtualbox" do |vb|
        # Set VM name
        vb.name = configs['machine_name']
        # Don't boot with headless mode
        # vb.gui = true

        if configs["machine_ram"] == "auto"
            host = RbConfig::CONFIG['host_os']
            # Give VM 1/4 system memory on the host
            if host =~ /darwin/
                mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
            elsif host =~ /linux/
                mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
            else # sorry Windows folks, I can't help you
                mem = 1024
            end
            vb.memory  = mem
        else
            vb.memory = configs["machine_ram"]
        end

        if configs["machine_cpu"] == "auto"
            host = RbConfig::CONFIG['host_os']
            # Give VM 1/4 of the system' cpu cores on the host
            if host =~ /darwin/
                cpus = `sysctl -n hw.ncpu`.to_i
            elsif host =~ /linux/
                cpus = `nproc`.to_i
            else # again, sorry Windows folks
                cpus = 2
            end
            vb.cpus   = cpus
        else
            vb.cpus   = configs["machine_cpu"]
        end
    end

    # Provisioning script
    srv.vm.provision "shell", path: "provision.sh", privileged: false, args:  "-a" + configs["mysql_root_pass"].to_s + " -b" + configs["mysql_user"].to_s+ " -c" + configs["mysql_user_pass"].to_s+ " -d" + configs["mysql_user_db"].to_s
end