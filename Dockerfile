# Alap Docker image, amely az Ubuntu 22.04-et használja
FROM ubuntu:22.04

# Frissítjük a csomaglistát és telepítjük a szükséges függőségeket
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    wget \
    git \
    subversion \
    libxml2-dev \
    libncurses5-dev \
    libssl-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    libjansson-dev \
    libedit-dev \
    uuid-dev \
    pkg-config \
    sudo \
    && apt-get clean

# Letöltjük és telepítjük az Asterisk legfrissebb verzióját
RUN cd /usr/src && \
    wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz && \
    tar -zxvf asterisk-20-current.tar.gz && \
    cd asterisk-20.* && \
    ./configure && \
    make menuselect.makeopts && \
    make && \
    make install && \
    make samples && \
    make config

# Engedélyezett fájlok és jogosultságok
RUN groupadd asterisk
RUN useradd -r -s /bin/false -g asterisk asterisk
RUN chown -R asterisk:asterisk /etc/asterisk

# Alapértelmezett parancs, amely elindítja az Asterisk-et
CMD ["/usr/sbin/asterisk", "-f"]

# Nyitott portok (általában a SIP kommunikációhoz szükséges)
EXPOSE 5060/udp 5061/tcp 8088/tcp


