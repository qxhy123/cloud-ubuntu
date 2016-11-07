FROM ubuntu:14.04
MAINTAINER Wu Zhangjin <wuzhangjin@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/ubuntu/

# Setup our Ubuntu sources (ADD breaks caching)
ADD sources.list /etc/apt/sources.list
RUN apt-get -y update

# Core
RUN apt-get install -y --force-yes --no-install-recommends \
	supervisor \
	software-properties-common \
	lxde x11vnc xvfb \
	openssh-server \
	pwgen sudo \
	vim net-tools \
	rsyslog fail2ban iptables \
	python-numpy \
	nodejs \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Fixup of rsyslog for fail2ban support
RUN sed -i -e "s/RepeatedMsgReduction on/RepeatedMsgReduction off/g" /etc/rsyslog.conf

ADD desktop /usr/share/desktop/

RUN mkdir /etc/startup.aux/
RUN echo "#Dummy" > /etc/startup.aux/00.sh
RUN chmod +x /etc/startup.aux/00.sh
ADD startup.sh /

RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/supervisord.conf

ADD noVNC /noVNC/
ADD tty.js /tty.js/

EXPOSE 6080
EXPOSE 3000
EXPOSE 22

WORKDIR /

ENTRYPOINT ["/startup.sh"]
