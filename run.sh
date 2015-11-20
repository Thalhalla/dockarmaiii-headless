#!/bin/bash

cd /home/steam
./arma3hc start
echo "started server"
sleep 10
echo "retreiving details"
sleep 3
./arma3hc details
sleep 300
# infinite loop to keep it open for Docker
while true; do ./arma3hc monitor; sleep 300; done
