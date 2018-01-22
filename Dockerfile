FROM php:7.2.1-apache
MAINTAINER Wouter Hummelink <wouter.hummelink@ordina.nl>
RUN apt-get update && apt-get install -y git zip unzip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
COPY ./demoapp/ /var/www/html/
RUN cd /var/www/html/ && ls -al && composer install
RUN ./bin/console debug:router
RUN apt-cache depends git
