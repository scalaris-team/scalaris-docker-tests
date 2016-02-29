FROM opensuse:13.1
MAINTAINER Nico Kruber <kruber@zib.de>

RUN zypper in -y  wget net-tools

RUN zypper addrepo --refresh "http://download.opensuse.org/repositories/home:/scalaris:/svn/openSUSE_13.1/home:scalaris:svn.repo"

RUN zypper --non-interactive --gpg-auto-import-keys ref

RUN zypper in -y  scalaris scalaris-doc scalaris-java python-scalaris python3-scalaris ruby-scalaris erlang-erlang_js erlang-hanoidb

ADD test.sh /
RUN chmod +x test.sh
