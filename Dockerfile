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

# and override this file with the command to start your server
USER root
COPY ./start.sh /start.sh
COPY ./run.sh /run.sh
RUN chmod 755 /run.sh \
    && chmod 755 /start.sh

WORKDIR /home/steam/steamcmd
RUN tar xvfz steamcmd_linux.tar.gz \
	&& chown -R steam. /home/steam

# ensure steam user is in tty group
RUN gpasswd -a steam tty

USER steam

RUN printenv

#RUN /home/steam/steamcmd/steamcmd.sh \
#        +login thalhallatyr 'asgard1776!' \
#        +force_install_dir /home/steam/arma3/ \
#        +app_update 233780 validate \
#        +quit


# Default tmux session
# Create the directories used to store the profile files and Arma3.cfg file
WORKDIR /home/steam
RUN echo 'new-session' >> ~/.tmux.conf 
RUN mkdir -p "/home/steam/.local/share/Arma 3" \
    && mkdir -p "/home/steam/.local/share/Arma 3 - Other Profiles"

# retrieve lgsm scripts
RUN wget http://gameservermanagers.com/dl/arma3server -O arma3server \
	&& chmod +x arma3server

# configure arma3server
RUN echo sed \
        && sed -i "s/steamuser=\"username\"/steamuser='thalhallatyr'/" arma3server \
        && sed -i "s/steampass=\"password\"/steampass='asgard1776!'/" arma3server \
        && sed -i "s/ip=\"0.0.0.0\"/ip='4.31.168.84'\ntarget_ip='162.248.91.24'/" arma3server

# force install the arma3 server binaries
RUN yes y|./arma3server install

# configure server to be a headless client
RUN sed -i \
    's|parms="-netlog -ip=${ip}|parms="-netlog -nosound -port=2302 -client -password= -connect=${target_ip} -BEpath=/home/steam/BE -ip=${ip}|' \
    /home/steam/arma3server

# configure ports to offset from default
# WORKDIR /home/steam/serverfiles/cfg
# RUN sed -i 's/serverport=2302/serverport=2402/' arma3-server.server.cfg \
#     && sed -i 's/steamport=2304/steamport=2404/' arma3-server.server.cfg \
#     && sed -i 's/steamqueryport=2303/steamqueryport=2403/' arma3-server.server.cfg

ENTRYPOINT ["/start.sh"]
