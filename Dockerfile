FROM centos:6
MAINTAINER adam@sensr.net

RUN yum -y install gcc-4.4.7 python-devel-2.6.6 MySQL-python-1.2.3 git-1.7.1 pam-devel-1.1.1 openssl-devel-1.0.1e bzip2 wget
 
# cd /usr/src; wget http://pypi.python.org/packages/source/z/zope.interface/zope.interface-3.7.0.tar.gz#md5=8f3e942e9556ed27ac1a71ee85bf697f
# cd /usr/src; gunzip -f zope.interface-3.7.0.tar.gz; tar -xvf zope.interface-3.7.0.tar 
# cd /usr/src/zope.interface-3.7.0; python setup.py install

ADD src/zope.interface-3.7.0.tar.gz /usr/src
RUN cd /usr/src/zope.interface-3.7.0 && python setup.py install

# cd /usr/src; wget http://pypi.python.org/packages/source/T/Twisted/Twisted-11.1.0.tar.bz2
# cd /usr/src; bunzip2 -f Twisted-11.1.0.tar.bz2
# cd /usr/src; tar -xvf Twisted-11.1.0.tar
# cd /usr/src/Twisted-11.1.0; python setup.py install

ADD src/Twisted-11.1.0.tar.bz2 /usr/src
RUN cd /usr/src/Twisted-11.1.0 && python setup.py install

# 
# # install monit 5.8.1
# cd /usr/src; wget wget http://mmonit.com/monit/dist/monit-5.8.1.tar.gz
# cd /usr/src; gunzip gunzip monit-5.8.1.tar.gz; tar xvf monit-5.8.1.tar
# cd /usr/src/monit-5.8.1; ./configure; make && make install
# 
# # add a deploy user
# useradd sensr
# passwd sensr # set it to the ususal
# useradd -g sensr deploy
# passwd deploy # set it to the ususal
# useradd ftpguest
# 


