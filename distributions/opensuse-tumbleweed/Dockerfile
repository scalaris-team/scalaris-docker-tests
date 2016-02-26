FROM opensuse:tumbleweed
MAINTAINER Christoph Kleineweber <kleineweber@zib.de>

RUN zypper addrepo "http://download.opensuse.org/repositories/home:/scalaris:/svn/openSUSE_Tumbleweed/home:xtreemfs:unstable.repo"

RUN zypper --non-interactive --gpg-auto-import-keys ref

RUN zypper in -y  scalaris

ADD test.sh /
RUN chmod +x test.sh
