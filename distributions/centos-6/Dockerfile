FROM centos:6
MAINTAINER Nico Kruber <kruber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN yum install -y wget
RUN cd /etc/yum.repos.d/ && wget http://download.opensuse.org/repositories/home:/scalaris:/svn/CentOS_6/home:scalaris:svn.repo
RUN yum install -y scalaris

ADD test.sh /
RUN chmod +x test.sh
