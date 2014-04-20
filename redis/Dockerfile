FROM tianon/centos:6.5
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum update -y

# install redis
RUN yum install -y curl tar make gcc && \
    cd /usr/local/src && \
    curl -O http://download.redis.io/releases/redis-2.8.8.tar.gz && \
    tar xf redis-2.8.8.tar.gz && \
    cd redis-2.8.8 && \
    make && \
    make install

EXPOSE 6379
CMD ["/usr/local/bin/redis-server"]
