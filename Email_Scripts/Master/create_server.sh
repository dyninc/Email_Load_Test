#!/bin/bash

INDEX=$1
AMI=$2
TT=$3

#start in the chef directory
cd ~/chef-repo/.chef

# bring up the new ec2 cloud server
sudo knife ec2 server create -G default -S <ec2 pem> -i /home/ubuntu/.ssh/<ec2 pem> -Z us-east-1c --flavor c1.medium -I $AMI -x ubuntu --server-url https://api.opscode.com/organizations/<your organization> > ~/mail_test/server_create_output$INDEX$TT.txt

# parse through the output of the knife create to get the newly created ip address
cat ~/mailsl_test/server_create_output$INDEX$TT.txt | grep -m 1 'Public IP Address' > ~/mail_test/public_ip_line$INDEX$TT.txt
PUBLIC_IP=`cat ~/mail_test/public_ip_line$INDEX$TT.txt | grep -o '[0-9]*[0-9]*[0-9][.][0-9]*[0-9]*[0-9][.][0-9]*[0-9]*[0-9][.][0-9]*[0-9]*[0-9]'`

# parse through the output of the knife create to get the newly created instance id
cat ~/mail_test/server_create_output$INDEX$TT.txt | grep -m 1 'Instance ID' > ~/mail_test/instance_id$INDEX$TT.txt
INSTANCEID=`cat ~/mail_test/instance_id$INDEX$TT.txt | grep -o 'i-[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]'`

echo $PUBLIC_IP >> ~/mail_test/hosts$TT.txt
echo $INSTANCEID >> ~/mail_test/servers$TT.txt

knife node delete -y $INSTANCEID

rm ~/mail_test/server_create_output$INDEX$TT.txt
rm ~/mail_test/instance_id$INDEX$TT.txt
rm ~/mail_test/public_ip_line$INDEX$TT.txt

