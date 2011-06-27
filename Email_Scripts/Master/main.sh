#!/bin/bash

IMAGES[1]="ami-fe639b97"
IMAGES[2]="ami-de639bb7"
IMAGES[3]="ami-ae639bc7"
IMAGES[4]="ami-bc639bd5"
IMAGES[5]="ami-9e639bf7"
IMAGES[6]="ami-62649c0b"
IMAGES[7]="ami-7a649c13"
IMAGES[8]="ami-4a649c23"
IMAGES[9]="ami-0a649c63"
IMAGES[10]="ami-e8649c81"

TT=`date +%s`

MACHINES=$1
MESSAGES=$2
TO=$6
DISCONNECT=$5
SERVER=$3
OLDSERVER=$4

if [ -z "$MACHINES" ]; then
echo "Incorrect parameters"
exit 1
fi

if [ $MACHINES = "-h" ]; then
echo "USAGE:  ./main machines messages [server] [oldserver] [open] [to]"
echo ""
echo "  machines: number of machines to start up"
echo "  messages: number of messages per machine"
echo "  server: mail server to relay to, defaults to smtp.sendlabs.com"
echo "  oldserver: server to replace, defaults to smtp.sendlabs.com"
echo "  open: true to reuse connections, defaults to a new connection each time"
echo "  to: email address to send to, defaults to <default address>"
echo ""
exit 1
fi

if ! [[ "$MACHINES" =~ ^[0-9]+$ ]] ; then
echo "machines must be a number"
echo ""
exit 1
fi

if ! [[ "$MESSAGES" =~ ^[0-9]+$ ]] ; then
echo "messages must be a number"
echo ""
exit 1
fi

#Build the servers if we have any to build
if [ $MACHINES -gt 0 ]; then
for i in `seq 1 $MACHINES`;
do
let SERVERNUM=i%10
let SERVERID=SERVERNUM+1
~/mail_test/create_server.sh $i ${IMAGES[SERVERID]} $TT &
echo "starting create of server $i => ${IMAGES[SERVERID]}..."
done  
wait
echo "servers have been created"
fi

# If we aren't sending to smtp.sendlabs.com, update the server we are sending to
if [ -n "$SERVER" ]; then
echo "Updating server to $SERVER"
 ~/mail_test/update_smtp.sh $TT $SERVER $OLDSERVER
fi

~/mail_test/start_servers.sh $TT $MESSAGES

#cleanup after ourselves
# ~/mail_test/delete_servers.sh
