FROM thalhalla/steamer
MAINTAINER James S. Moore <james 'at' ohmydocker com>

USER root
ENV DOCKARMAIIIHC_UPDATED 2015121001

EXPOSE 2302
EXPOSE 2303
EXPOSE 2304
EXPOSE 2305
EXPOSE 2344
EXPOSE 2345

# override these variables in your Dockerfile
#ENV STEAM_USERNAME anonymous
#ENV STEAM_PASSWORD ' '
#ENV STEAM_GUARD_CODE ' '
#ENV TARGET_IP ' '
#ENV IP ' '
#ENV SERVER_PASSWORD ' '

# ensure steam user is in tty group
RUN gpasswd -a steam tty

USER steam
WORKDIR /home/steam
#RUN ./steamcmd/steamcmd.sh \
#        +login $STEAM_USERNAME $STEAM_PASSWORD \
#        +force_install_dir ./arma3/ \
#        +app_update 233780 validate \
#        +quit

# and override this file with the command to start your server
COPY ./start.sh /start.sh
COPY ./run.sh /run.sh
RUN chmod 755 /run.sh \
    && chmod 755 /start.sh

# Default tmux session
# Create the directories used to store the profile files and Arma3.cfg file
RUN echo 'new-session' >> ~/.tmux.conf \
    && mkdir -p "~/.local/share/Arma 3" \
    && mkdir -p "~/.local/share/Arma 3 - Other Profiles"

WORKDIR /home/steam
#RUN wget http://gameservermanagers.com/dl/arma3server -O arma3hc \
#    && chmod +x arma3hc 

# configure arma3hc
#RUN echo sed \
#        && sed -i "s/steamuser=\"anonymous\"/steamuser='$STEAM_USERNAME'/" arma3hc \
#        && sed -i "s/steampass=\" \"/steampass='$STEAM_PASSWORD'/" arma3hc \
#        && sed -i "s/ip=\"0.0.0.0\"/ip='$IP'\ntarget_ip='$TARGET_IP'/" arma3hc

# force install the arma3 server binaries
#RUN yes y|./arma3hc install

# configure server to be a headless client
#RUN sed -i \
#    's|parms="-netlog -ip=${ip}|parms="-netlog -nosound -port=2302 -client -password=$PASSWORD -connect=${target_ip} -BEpath=/home/steam/BE -ip=${ip}|' \
#    /home/steam/arma3hc

# configure ports to offset from default
# WORKDIR /home/steam/serverfiles/cfg
# RUN sed -i 's/serverport=2302/serverport=2402/' arma3-server.server.cfg \
#     && sed -i 's/steamport=2304/steamport=2404/' arma3-server.server.cfg \
#     && sed -i 's/steamqueryport=2303/steamqueryport=2403/' arma3-server.server.cfg

ENTRYPOINT ["/start.sh"]
