FROM php8.1-apache
COPY . /var/www/html
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
EXPOSE 80
