FROM openjdk:8

## Copied from https://bitbucket.org/tigerilla/mirth-connect-docker

# http://downloads.mirthcorp.com/archive/connect/
# Specify version of Mirth!
# ENV MIRTH_CONNECT_VERSION 3.0.1.7051.b1075 
ENV MIRTH_CONNECT_VERSION 3.4.2.8129.b167

# Mirth Connect is run with user `connect`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN useradd -u 1000 mirth

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.9
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget gettext && rm -rf /var/lib/apt/lists/* \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# Expose mirth appdata volume
VOLUME /opt/mirth-connect/appdata



# Download and install Mirth Connect
RUN \
  cd /tmp && \
  wget http://downloads.mirthcorp.com/connect/$MIRTH_CONNECT_VERSION/mirthconnect-$MIRTH_CONNECT_VERSION-unix.tar.gz && \
  tar xvzf mirthconnect-$MIRTH_CONNECT_VERSION-unix.tar.gz && \
  rm -f mirthconnect-$MIRTH_CONNECT_VERSION-unix.tar.gz && \
  mv Mirth\ Connect/* /opt/mirth-connect/ && \
  chown -R mirth /opt/mirth-connect 

WORKDIR /opt/mirth-connect

# Expose the default Mirth Ports
EXPOSE 8080 8443


# copy to mapped drive... We could also just leave it in scripts
# COPY ./IVLMirthLibrary.js /home/files/scripts
# COPY ./wait-for-it.sh /
COPY ./docker-entrypoint.sh /
COPY ./mirth.properties.template /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "java", "-jar", "mirth-server-launcher.jar"]
