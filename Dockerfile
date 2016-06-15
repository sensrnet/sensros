FROM centos:6
MAINTAINER adam@sensr.net

# need compiler to build ruby and some gems
RUN yum -y groupinstall 'Development Tools'

# needed for openssl to be part of ruby and git
RUN yum install -y curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel

# from provision file
RUN yum install -y jwhois rsync openssh-clients wget telnet nc

# calls host on an IP address and returns its reverse dns
RUN yum -y install bind-utils

# Note: it might make sense to record the version numbers here
RUN  yum -y install make
RUN  yum -y install gcc-c++
RUN  yum -y install libjpeg-devel
RUN  yum -y install python-devel
RUN  yum -y install mysql-devel
RUN  yum -y install MySQL-python
RUN  yum -y install git
RUN  yum -y install libcurl-devel
RUN  yum -y install libffi-devel
# for opencv
RUN  yum -y install gtkhtml2-devel cmake numpy
# 
RUN yum -y install opencv-2.0.0
RUN yum -y install opencv-devel-2.0.0
  
# needed to build ruby
ADD src/yaml-0.1.4.tar.gz /tmp/
RUN cd /tmp/yaml-0.1.4/ \
  && ./configure && make && make install

# make ruby 
ADD src/ruby-1.9.3-p551.tar.bz2 /tmp/
RUN cd /tmp/ruby-1.9.3-p551/ && ./configure && make && make install


# for nokogiri
RUN yum install -y libxml2-devel libxslt-devel

RUN gem install --no-rdoc --no-ri rails -v '~> 2.3.5' 
RUN gem install --no-rdoc --no-ri mongrel -v '>= 1.2.0.pre2'
RUN gem install --no-rdoc --no-ri passenger  -v '~> 2.2.5'
RUN gem install --no-rdoc --no-ri mongo -v '~> 1.6.1'
RUN gem install --no-rdoc --no-ri mysql -v '~> 2.8.1' # can't find plus mysqlplus -v '~> 0.1.1'
RUN gem install --no-rdoc --no-ri right_aws -v '~> 2.0.0' 
RUN gem install --no-rdoc --no-ri cgi_multipart_eof_fix -v '~> 2.5.0' 
RUN gem install --no-rdoc --no-ri curb -v '~> 0.6.6.0' 
RUN gem install --no-rdoc --no-ri gdata-19 -v '~> 1.1.2' 
RUN gem install --no-rdoc --no-ri geocoder -v '~> 1.1.1' 
RUN gem install --no-rdoc --no-ri bson_ext -v=1.6.1

# for ffmpeg
ADD src/yasm-1.2.0.tar.gz /tmp
RUN cd /tmp/yasm-1.2.0 && ./configure && make && make install

# h264
RUN cd /tmp && git clone git://git.videolan.org/x264 && cd x264 && git checkout a01e339 && \
    ./configure --enable-shared && make && make install
# lame
ADD src/lame-3.99.tar.gz /tmp
RUN cd /tmp/lame-3.99 && ./configure && make && make install

# libtheora and libvorbis
ADD src/libogg-1.3.0.tar.xz /tmp
RUN cd /tmp/libogg-1.3.0 && ./configure && make && make install
# TOM: theora needs to be able to find the dynamic library.  ffmpeg needs it too
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/libogg.conf && ldconfig

# theora video encoder
ADD src/libtheora-1.1.1.tar.gz /tmp
RUN cd /tmp/libtheora-1.1.1 && ./configure && make && make install

# Vorbis audio encoder
ADD src/libvorbis-1.3.2.tar.gz /tmp
RUN cd /tmp/libvorbis-1.3.2 && ./configure && make && make install

# VisualOn AAC audio encoder
ADD src/vo-aacenc-0.1.1.tar.gz /tmp
RUN cd /tmp/vo-aacenc-0.1.1 && ./configure && make && make install

# VP8 Video encoder
RUN cd /tmp &&  git clone https://chromium.googlesource.com/webm/libvpx && cd /tmp/libvpx && git checkout ce88a829984 && \
    ./configure --disable-examples  && \
    make && make install

RUN cd /tmp && git clone git://git.videolan.org/ffmpeg && cd /tmp/ffmpeg && git checkout 3a3f2b515fa && \
    ./configure --enable-libmp3lame \ 
	--enable-libtheora \
	--enable-libvo-aacenc \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libx264 \
	--enable-version3 \
	--enable-gpl && \
    make && make install

# make OpenCV
# ADD src/OpenCV-2.3.1a.tar.bz2 /tmp/
# RUN cd /tmp/OpenCV-2.3.1/ &&   \
#   mkdir release &&  cd release &&  cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr -D BUILD_PYTHON_SUPPORT=ON ..  && \
#   make && make install

# build inotify
# wget "http://nbtsc.org/~aredridel/projects/ruby/ruby-inotify-0.0.2.tar.gz"
ADD src/ruby-inotify-0.0.2.tar.gz /tmp/
RUN cd /tmp/ruby-inotify-0.0.2/  \
  && sed -i.bak -e 's/rake\/rdoctask/rdoc\/task/' -e 's/Rake::RDocTask.new/RDoc::Task.new/' Rakefile \
  && rake build && make install

# remove /tmp/stuff
RUN rm -rf /tmp/anaconda-post.log /tmp/ffmpeg /tmp/lame-3.99 /tmp/libogg-1.3.0 /tmp/libtheora-1.1.1 /tmp/libvorbis-1.3.2 /tmp/libvpx /tmp/ruby-1.9.3-p551 /tmp/ruby-inotify-0.0.2 /tmp/vo-aacenc-0.1.1 /tmp/x264 /tmp/yaml-0.1.4 /tmp/yasm-1.2.0 /tmp/yum.log
