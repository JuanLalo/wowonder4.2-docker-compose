# Use the official PHP image with Apache and extend it with necessary extensions
FROM php:7.4-apache

# Maintainer information label
LABEL maintainer="Eduardo Rosales <eduardorosales720@gmail.com>"

# Update package index and install dependencies
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        libjpeg-dev \
        libpng-dev \
        default-mysql-client \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Enable the mod_rewrite module for Apache
RUN a2enmod rewrite

# Install necessary PHP extensions for Wowonder and phpMyAdmin
RUN docker-php-ext-install mysqli pdo pdo_mysql zip gd exif

# Set the working directory
WORKDIR /var/www/html/wowonder

# Copy your application files to the working directory in the container
COPY . .

# Download and install phpMyAdmin in the subdirectory
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.tar.gz \
    && mkdir /var/www/html/phpmyadmin \
    && tar xzf phpMyAdmin-5.1.1-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin \
    && rm phpMyAdmin-5.1.1-all-languages.tar.gz

# Expose port 80 for the web server
EXPOSE 80

# Command to start the web server
CMD ["apache2-foreground"]
