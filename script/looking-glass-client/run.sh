#!/bin/bash
directory=`echo $PWD`
ssh root@localhost pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "$directory/sleekglass.sh" &
exit 0;
