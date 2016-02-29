FROM centos:6
MAINTAINER Nico Kruber <kruber@zib.de>

ENV DEBIAN_FRONTEND noninteractive

RUN cd /etc/yum.repos.d/ && curl -L --remote-name "http://download.opensuse.org/repositories/home:/scalaris:/testing/CentOS_6/home:scalaris:testing.repo" ; cd -
RUN curl -L -o repo.rpm "http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm" && yum install --nogpgcheck -y repo.rpm && rm repo.rpm
RUN yum install -y scalaris scalaris-doc scalaris-java python-scalaris ruby-scalaris wget erlang-js erlang-hanoidb

ADD test.sh /
RUN chmod +x test.sh
