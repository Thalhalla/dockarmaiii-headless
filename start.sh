#!/bin/bash

cd /home/steam
echo sed
sed -i 's/steamuser="username"/steamuser=REPLACE_USER/' arma3hc
sed -i 's/steampass="password"/steampass=REPLACE_PASSWORD/' arma3hc
sed -i "s/steamuser=REPLACE_USER/steamuser='$STEAM_USERNAME'/" arma3hc
sed -i "s/steampass=REPLACE_PASSWORD/steampass='$STEAM_PASSWORD'/" arma3hc
set_steam_guard_code $STEAM_GUARD_CODE
yes y|./arma3hc install
/bin/bash /run.sh
