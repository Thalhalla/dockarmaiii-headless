FROM joshuacox/steamer
MAINTAINER James S. Moore <james 'at' webtechhq com>

USER root
ENV DOCKARMAIIIHC_UPDATED 2015091201

EXPOSE 2302
EXPOSE 2303
EXPOSE 2304
EXPOSE 2305
EXPOSE 2344
EXPOSE 2345

# override these variables in your Dockerfile
ENV STEAM_USERNAME anonymous
ENV STEAM_PASSWORD ' '
ENV STEAM_GUARD_CODE ' '
# and override this file with the command to start your server
USER root
ADD ./run.sh /run.sh
RUN chmod 755 /run.sh
# Override the default start.sh
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
RUN gpasswd -a steam tty

USER steam
RUN echo 'new-session' >> ~/.tmux.conf
# Create the directories used to store the profile files and Arma3.cfg file
RUN mkdir -p "~/.local/share/Arma 3"
RUN mkdir -p "~/.local/share/Arma 3 - Other Profiles"
# RUN rm -Rf /home/steam/steamcmd
WORKDIR /home/steam
RUN wget http://gameservermanagers.com/dl/arma3server
RUN chmod +x arma3server

ENTRYPOINT ["/start.sh"]
