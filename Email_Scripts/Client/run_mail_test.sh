#/bin/bash

CONNECTIONS=$1
MESSAGES=$3
SIZE=$2
DISCONNECT=$4
FROM=$6
TO=$5

#if no size is given, default to 26KB
if [ -z "$SIZE" ]
then
SIZE=3328
fi

#check if disconnect is overridden
if [ -z "$DISCONNECT" ]; then
DISCONNECT=
else
if [ $DISCONNECT = "true" ]; then
DISCONNECT='-d '
else
DISCONNECT=
fi
fi

# if no connections are given, default it to 1... you know, the basic test case
if [ -z "$CONNECTIONS" ]
then
CONNECTIONS=1
fi

#if no number of messages are given, have each connection send one
if [ -z "$MESSAGES" ]
then
MESSAGES=$CONNECTIONS
fi

#if no size is given, default to 26KB
if [ -z "$TO" ]
then
TO='<to address>'
fi

#if no size is given, default to 26KB
if [ -z "$FROM" ]
then
FROM='<from address>'
fi

echo 'Starting test with '$CONNECTIONS' connections to send '$MESSAGES' messages of size' $SIZE 'to '$TO' from '$FROM

sudo smtp-source -s $CONNECTIONS -l $SIZE -m $MESSAGES -c $DISCONNECT -f $FROM -t $TO localhost:25