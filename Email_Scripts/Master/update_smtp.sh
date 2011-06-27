#!/bin/bash
NEWSERVER=$2
OLDSERVER=$3
TT=$1

if [ -z "$OLDSERVER" ]; then
OLDSERVER=<default original server>
fi

#update the relayhost in the main config
parallel-ssh -h hosts$TT.txt -P -v -l ubuntu "sudo sed -i 's/${OLDSERVER}/'${NEWSERVER}'/g' /etc/postfix/sasl_passwd"

#update the server in the password file
parallel-ssh -h hosts$TT.txt -P -v -l ubuntu "sudo sed -i 's/${OLDSERVER}/'${NEWSERVER}'/g' /etc/postfix/main.cf"

#regenerate the password file
parallel-ssh -h hosts$TT.txt -P -v -l ubuntu 'sudo postmap hash:/etc/postfix/sasl_passwd'

#reload postfix
parallel-ssh -h hosts$TT.txt -P -v -l ubuntu 'sudo postfix reload'
