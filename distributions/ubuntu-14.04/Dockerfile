FROM ubuntu:14.04.1
MAINTAINER Nico Kruber <kruber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qy dist-upgrade
RUN apt-get -qy install wget

RUN echo "deb http://download.opensuse.org/repositories/home:/scalaris:/svn/xUbuntu_14.04 ./" >> /etc/apt/sources.list
RUN wget -q http://download.opensuse.org/repositories/home:/scalaris:/svn/xUbuntu_14.04/Release.key -O - | apt-key add -
RUN apt-get -qy update

RUN apt-get -qy install scalaris scalaris-doc scalaris-java python-scalaris python3-scalaris scalaris-ruby

ADD test.sh /
RUN chmod +x test.sh
