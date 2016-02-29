FROM fedora:23
MAINTAINER Nico Kruber <kruber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN dnf install -y wget
RUN cd /etc/yum.repos.d/ && wget http://download.opensuse.org/repositories/home:/scalaris:/svn/Fedora_23/home:scalaris:svn.repo
RUN dnf install -y scalaris scalaris-doc scalaris-java python-scalaris python3-scalaris ruby-scalaris erlang-js erlang-hanoidb

ADD test.sh /
RUN chmod +x test.sh
