FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y apache2

WORKDIR /var/www/html

RUN echo "Hello World" > index.html

CMD ["apache2ctl", "-D", "FOREGROUND"]
