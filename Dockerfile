FROM php:8.1-apache

# Set the working directory
WORKDIR /var/www/html

# Install required packages
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libgmp-dev \
    libicu-dev \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd bcmath ctype fileinfo json mbstring openssl pdo pdo_mysql tokenizer xml curl gmp \
    && a2enmod rewrite

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/html/ && chmod -R 755 /var/www/html/

# Copy the project files to the container
COPY . /var/www/html/

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80
