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



# Run query on your MSSQL Docker Database...
# WITH channels AS (
# 	SELECT c.NAME, CAST(c.CHANNEL AS XML) ChannelInfo
# 	FROM CHANNEL c
# ) 
# SELECT DISTINCT '- "' + n.c.value('.', 'varchar(20)') + ':' + n.c.value('.', 'varchar(20)') + '" '
# FROM channels c
# 	CROSS APPLY c.ChannelInfo.nodes('/channel/sourceConnector/properties/listenerConnectorProperties/port') N(c)	


# EXPOSE 7777 7778 8777 8778
# EXPOSE 30570 30575 51000 51001
# EXPOSE 60100-61100

EXPOSE 60588 60537 60527 60557 60560 60301 60570 61006 60400 60200 60401 60535 60556 60559 60522 7777 
EXPOSE 51000 60565 60547 60562 60576 60523 60571 60569 60541 60574 60519 60528 60900 60587 60579 60567 
EXPOSE 60521 60584 60586 60572 60553 7777 60583 60800 60561 60532 60568 60533 60563 8777 60525 60530 
EXPOSE 30570 60542 60589 60573 60548 61002 60578 60551 60545 60558 60546 60550 60524 60508 60581 60585 
EXPOSE 60580 30575 60592 61001 60534 60300 60543 60552 60564 60520 60536 60555 61003 60518 7778 60566 
EXPOSE 60539 60100 60531 60577 60509 60526 60544 60582 51001 60538 60529 60575 8778 

# copy to mapped drive... We could also just leave it in scripts
# COPY ./IVLMirthLibrary.js /home/files/scripts
# COPY ./wait-for-it.sh /
COPY ./docker-entrypoint.sh /
COPY ./mirth.properties.template /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "java", "-jar", "mirth-server-launcher.jar"]
