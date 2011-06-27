#!/bin/bash
TT=$1

#sudo knife ec2 server delete 
cd ~/chef-repo/.chef

while read line    
do    
    sudo knife ec2 server delete -y $line    
done <~/mail_test/servers$TT.txt 

sudo rm ~/mail_test/servers$TT.txt
sudo rm ~/mail_test/hosts$TT.txt