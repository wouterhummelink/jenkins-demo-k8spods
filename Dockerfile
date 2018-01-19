FROM centos/php-70-centos7:7.0
MAINTAINER Wouter Hummelink <wouter.hummelink@ordina.nl>
RUN yum -y update && \
    yum -y install epel-release centos-scl-release && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ADD ./src 

COMMIT

