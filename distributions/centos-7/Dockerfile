FROM centos:7
MAINTAINER Nico Kruber <kruber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN cd /etc/yum.repos.d/ && curl -L --remote-name "http://download.opensuse.org/repositories/home:/scalaris:/testing/CentOS_7/home:scalaris:testing.repo" ; cd -
RUN yum install -y scalaris scalaris-doc scalaris-java python-scalaris ruby-scalaris wget erlang-hanoidb

ADD test.sh /
RUN chmod +x test.sh
