FROM fedora:22
MAINTAINER Nico Kruber <kruber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN yum install -y wget
RUN cd /etc/yum.repos.d/ && wget http://download.opensuse.org/repositories/home:/scalaris:/testing/Fedora_22/home:scalaris:testing.repo
RUN dnf install -y scalaris scalaris-doc scalaris-java python-scalaris python3-scalaris ruby-scalaris erlang-js erlang-hanoidb

ADD test.sh /
RUN chmod +x test.sh
