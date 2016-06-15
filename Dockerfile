FROM centos:5.11
MAINTAINER adam@sensr.net

# need compiler to build ruby and some gems
RUN yum -y groupinstall 'Development Tools'

# needed for openssl to be part of ruby and git
RUN yum install -y curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel

# needed to build ruby
ADD yaml-0.1.4.tar.gz /tmp/
RUN cd /tmp/yaml-0.1.4/ \
  && ./configure && make && make install && rm -rf /tmp/yaml-0.1.4

# make ruby
ADD ruby-1.9.3-p551.tar.bz2 /tmp/
RUN cd /tmp/ruby-1.9.3-p551/ \
  && ./configure && make && make install && rm -rf /tmp/ruby-1.9.3-p551

# for mysql
RUN yum install -y mysql mysql-devel

# make git
ADD git-1.8.2.3.tar.bz2 /tmp/
RUN cd /tmp/git-1.8.2.3 \
 && make configure \
 && ./configure \
 && make install \
 && rm -rf /tmp/git-1.8.2.3

# for nokogiri
RUN yum install -y libxml2-devel libxslt-devel

RUN gem install --no-rdoc --no-ri bundler -v 1.1
RUN gem install --no-rdoc --no-ri rails -v 3.2.0




