# docker-ngx_mruby-centos
FROM tianon/centos:6.5
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

# install epel (for GeoIP-devel)
RUN yum install -y http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

# update RPMs
RUN yum update -y

# build ruby
RUN yum install -y tar gcc && \
    cd /usr/local/src && \
    curl -O http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz && \
    tar xf ruby-2.1.1.tar.gz && \
    cd /usr/local/src/ruby-2.1.1 && \
    ./configure --prefix /usr/local/ruby && \
    make && \
    make install && \
    rm -rf /usr/local/src/ruby-2.1.1 ruby-2.1.1.tar.gz

# build redis
RUN yum install -y curl tar make gcc && \
    cd /usr/local/src && \
    curl -O http://download.redis.io/releases/redis-2.8.8.tar.gz && \
    tar xf redis-2.8.8.tar.gz && \
    cd redis-2.8.8 && \
    make && \
    make install

# build hiredis
RUN yum install -y git && \
    cd /usr/local/src && \
    git clone https://github.com/redis/hiredis && \
    cd hiredis && \
    make && \
    make install INSTALL_LIBRARY_PATH=/usr/local/lib64 && \
    echo /usr/local/lib64 > /etc/ld.so.conf.d/hiredis.conf && \
    ldconfig

# build pcre
RUN yum install -y gcc-c++ && \
    cd /usr/local/src && \
    curl -L -o pcre-8.35.tar.gz http://sourceforge.net/projects/pcre/files/pcre/8.35/pcre-8.35.tar.gz/download && \
    tar xf pcre-8.35.tar.gz && \
    cd pcre-8.35 && \
    ./configure --prefix=/usr/local --libdir=/usr/local/lib64 \
      --enable-jit --enable-utf && \
    make && \
    make install && \
    echo /usr/local/lib64 > /etc/ld.so.conf.d/pcre-8.35.x86_64.conf && \
    ldconfig

# build ngx_mruby
RUN yum install -y bison git wget openssl-devel && \
    cd /usr/local/src && \
    git clone git://github.com/matsumoto-r/ngx_mruby.git && \
    cd ngx_mruby && \
    git submodule init && \
    git submodule update && \
    cd /usr/local/src/ngx_mruby && \
    sed -i.orig "s|conf.gem :git => 'git://github.com/matsumoto-r/mruby-memcached.git'|#&|;/^  conf.gem :git => 'git:\/\/github.com\/mattn\/mruby-onig-regexp.git'/a\
\  conf.gem :git => 'git://github.com/iij/mruby-env.git'" \
      build_config.rb && \
    cd /usr/local/src && \
    curl -O http://nginx.org/download/nginx-1.4.7.tar.gz && \
    tar xf nginx-1.4.7.tar.gz && \
    cd /usr/local/src/ngx_mruby && \
    PATH=/usr/local/ruby/bin:$PATH \
      NGINX_CONFIG_OPT_ENV='--prefix=/usr/local/nginx' \
      NGINX_SRC_ENV='/usr/local/src/nginx-1.4.7' \
      sh build.sh

# build nginx with mruby
#
# Configuration summary
#   + using PCRE library: /usr/local/src/pcre-8.35
#   + using system OpenSSL library
#   + md5: using OpenSSL library
#   + sha1: using OpenSSL library
#   + using system zlib library
# 
#   nginx path prefix: "/usr/local/nginx"
#   nginx binary file: "/usr/local/nginx/sbin/nginx"
#   nginx configuration prefix: "/usr/local/nginx/conf"
#   nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
#   nginx pid file: "/usr/local/nginx/logs/nginx.pid"
#   nginx error log file: "/usr/local/nginx/logs/error.log"
#   nginx http access log file: "/usr/local/nginx/logs/access.log"
#   nginx http client request body temporary files: "client_body_temp"
#   nginx http proxy temporary files: "proxy_temp"
#   nginx http fastcgi temporary files: "fastcgi_temp"
#   nginx http uwsgi temporary files: "uwsgi_temp"
#   nginx http scgi temporary files: "scgi_temp"
#
RUN yum install -y openssl-devel zlib-devel libxslt-devel gd-devel \
      GeoIP-devel httpd-tools && \
    cd /usr/local/src/nginx-1.4.7 && \
    ./configure --prefix=/usr/local/nginx \
      --user=nginx \
      --group=nginx \
      --with-file-aio \
      --with-ipv6 \
      --with-http_ssl_module \
      --with-http_realip_module \
      --with-http_addition_module \
      --with-http_xslt_module \
      --with-http_image_filter_module \
      --with-http_geoip_module \
      --with-http_sub_module \
      --with-http_dav_module \
      --with-http_flv_module \
      --with-http_mp4_module \
      --with-http_gzip_static_module \
      --with-http_random_index_module \
      --with-http_secure_link_module \
      --with-http_degradation_module \
      --with-http_stub_status_module \
      --with-md5-asm \
      --with-sha1-asm \
      --with-pcre-jit --with-pcre=/usr/local/src/pcre-8.35 \
      --with-cc-opt='-O2 -g' \
      --add-module=/usr/local/src/ngx_mruby \
      --add-module=/usr/local/src/ngx_mruby/dependence/ngx_devel_kit && \
    make && \
    useradd -r -d /usr/local/nginx -s /sbin/nologin \
      -c 'nginx web server with mruby' nginx && \
    make install

ADD conf/ /usr/local/nginx/conf/
ADD html/ /usr/local/nginx/html/
EXPOSE 80
CMD ["/usr/local/nginx/sbin/nginx"]
