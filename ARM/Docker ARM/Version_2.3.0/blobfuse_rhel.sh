#!/bin/sh
# Add Microsoft Package Respository
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
#sudo yum install blobfuse
sudo mkdir /mnt/blobfuse -p
sudo chown oracle /mnt/blobfuse/
sudo chmod -R ugo+rw /mnt/blobfuse/
mkdir /mnt/blobfuse/$2

#echo "export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1" | sudo tee -a /home/oracle/.bashrc
#echo "export ORACLE_SID=cdb1" | sudo tee -a /home/oracle/.bashrc
#echo "export ORACLE_BASE=/u01/app/oracle" | sudo tee -a /home/oracle/.bashrc

printf 'accountName '$1'\naccountKey '$3'\ncontainerName '$2'\n' | tee /etc/fuse_connection.cfg
printf 'blobfuse /mnt/blobfuse/'$2' --tmp-path=/mnt/ramdisk/blobfusetmp --config-file=/etc/fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 --log-level=LOG_DEBUG --file-cache-timeout-in-seconds=120 -o allow_other' | sudo tee /etc/bf.sh
sudo chmod 600 /etc/fuse_connection.cfg
# Download AzCopy
sudo mkdir /azcopy
sudo chmod 777 /azcopy
cd /azcopy
sudo curl -L https://aka.ms/downloadazcopy-v10-linux | tar xvz
sudo chmod 555 /azcopy

# Ansible
#sudo yum install -y python3-pip
#pip3 install ansible[azure]

# Install Ansible modules and plugins for interacting with Azure.
#ansible-galaxy collection install azure.azcollection