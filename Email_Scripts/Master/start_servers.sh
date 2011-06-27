#!/bin/bash

TT=$1
MESSAGES=$2

# calculate the amount of times we can do our whole number 80, 15 and 5 percent calculations for
let LOOPS=$MESSAGES/20
let REMAIN=$MESSAGES%20

#if there are more thean 20 messages, split them into their respective 80/15/5 pool for size then run them
if [ $LOOPS -gt 0 ]; then
let FIRST=$LOOPS*16
let SECOND=$LOOPS*1
let THIRD=$LOOPS*3
parallel-ssh -h hosts$TT.txt -P -t -1 -v -l ubuntu "dash -c 'time --output=/home/ubuntu/mail_stress/log -f\"%e\" sudo ~/mail_stress/run_mail_test.sh 249 26624 ${FIRST} ${DISCONNECT} ${TO}'"

parallel-ssh -h hosts$TT.txt -P -t -1 -v -l ubuntu 'sudo ~/mail_stress/run_mail_test.sh 249 10240 '$SECOND $DISCONNECT $TO

parallel-ssh -h hosts$TT.txt -P -t -1 -v -l ubuntu 'sudo ~/mail_stress/run_mail_test.sh 249 102400 '$THIRD $DISCONNECT $TO

# now lets print the messages per second for the largest sent burst
parallel-ssh -h hosts$TT.txt -P -t -1 -v -l ubuntu "echo 'Messages Per Second:'; echo \"100/\`cat /home/ubuntu/mail_stress/log\`\" | bc"
fi

# if we had messages outside the even 20 bucket, send them as the average size
if [ $REMAIN -gt 0 ]; then
parallel-ssh -h hosts$TT.txt -P -t -1 -v -l ubuntu "dash -c 'time --output=/home/ubuntu/mail_stress/log -f\"%e\" sudo ~/mail_stress/run_mail_test.sh 249 26624 ${REMAIN} ${DISCONNECT} ${TO}'"

# only calculate the average messages per second here if we never hit the loop calculation...
if [ $LOOPS -lt 1 ]; then
parallel-ssh -h hosts$TT.txt -P -t -1 -v -l ubuntu "echo 'Messages Per Second:'; echo \"100/\`cat /home/ubuntu/mail_stress/log\`\" | bc"
fi
fi
