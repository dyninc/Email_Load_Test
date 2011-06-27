for file in `ls /home/ubuntu/mail_test`
do
if [[ $file == *hosts* ]]; then
TEMP1=${file%.txt}
TEMP2=${TEMP1#hosts}
~/mail_test/delete_servers.sh $TEMP2
fi
done
