FROM opensuse:tumbleweed
MAINTAINER Christoph Kleineweber <kleineweber@zib.de>

RUN zypper addrepo "http://download.opensuse.org/repositories/home:/xtreemfs:/unstable/openSUSE_Tumbleweed/home:xtreemfs:unstable.repo"

RUN zypper --non-interactive --gpg-auto-import-keys ref

RUN zypper in -y  xtreemfs-server xtreemfs-client

ADD test.sh /
RUN chmod +x test.sh
