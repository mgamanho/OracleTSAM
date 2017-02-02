#!/bin/sh
HOSTNAME=`hostname`
source $TUXDIR/tux.env
$TUXDIR/bin/tlisten -l "//$HOSTNAME:$1" -j "rmi://$HOSTNAME:$2"
