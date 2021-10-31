export FIRST_RUN='true'
vagrant up --no-provision
vagrant ssh -c 'sudo apt-get update --fix-missing'
vagrant ssh -c 'sudo apt-get upgrade -y'
vagrant ssh -c 'sudo apt-get install -y build-essential linux-headers-amd64 linux-image-amd64 python-pip'
vagrant halt
export FIRST_RUN='false'
vagrant up