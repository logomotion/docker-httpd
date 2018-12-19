FROM ubuntu:bionic

ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $HTTPD_PREFIX/bin:$PATH
RUN mkdir -p "$HTTPD_PREFIX" \
    && chown www-data:www-data "$HTTPD_PREFIX"
WORKDIR $HTTPD_PREFIX

RUN apt update \
    && apt install -y --no-install-recommends \
    apache2 curl git vim wget libapache2-mod-fcgid software-properties-common\
    && rm -r /var/lib/apt/lists/*
RUN a2enmod ssl rewrite actions fcgid alias proxy_fcgi
RUN sed -i '/Global configuration/a \
ServerName localhost \
' /etc/apache2/apache2.conf
EXPOSE 80 443
RUN rm -f /run/apache2/apache2.pid
CMD apachectl  -DFOREGROUND -e info