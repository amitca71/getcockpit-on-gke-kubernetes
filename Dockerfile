FROM agentejo/cockpit:latest
COPY 000-default.conf /etc/apache2/sites-enabled
COPY docker-php.conf /etc/apache2/conf-available
COPY index.html /var/www/html
