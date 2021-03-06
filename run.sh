#!/bin/bash

. defs.sh

OPTS="-p -n100000000"

trap "sudo killall send recv" 0

old_drops=$(ethtool -S $RECV_DEV | grep rx_nodesc_drops | cut -d: -f2)
sudo taskset 040 env LD_LIBRARY_PATH=$LIBPATH ./recv $OPTS $RECV_DEV &
sleep 1
sudo taskset 020 env LD_LIBRARY_PATH=$LIBPATH ./send $OPTS $SEND_DEV $(ifconfig $RECV_DEV | perl -ne 'print $1 if (/HWaddr (\S*)/)')
new_drops=$(ethtool -S $RECV_DEV | grep rx_nodesc_drops | cut -d: -f2)
echo "rx_nodesc_drops delta: " $(expr $new_drops - $old_drops)
wait
