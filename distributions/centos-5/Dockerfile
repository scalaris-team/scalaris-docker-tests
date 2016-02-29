FROM centos:5
MAINTAINER Nico Kruber <kruber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN yum install -y curl
RUN cd /etc/yum.repos.d/ && curl -L --remote-name "http://download.opensuse.org/repositories/home:/scalaris:/testing/CentOS_5/home:scalaris:testing.repo" ; cd -
RUN curl -L -o repo.rpm "http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm" && yum install --nogpgcheck -y repo.rpm && rm repo.rpm
RUN yum install -y scalaris scalaris-doc scalaris-java ruby-scalaris erlang-hanoidb wget

ADD test.sh /
RUN chmod +x test.sh
