# Use the official PHP image with Apache as the base
FROM php:8.1-apache

# Install required system packages and PHP extensions
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
    cron \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd bcmath ctype fileinfo json mbstring openssl pdo pdo_mysql tokenizer xml curl gmp \
    && a2enmod rewrite

# Install Composer globally (for managing PHP dependencies)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application files into the container
COPY . /var/www/html/

# Set the correct permissions for the application files
RUN chown -R www-data:www-data /var/www/html/ && chmod -R 755 /var/www/html/

# Configure cron jobs if necessary
COPY ./cron-job.sh /etc/cron.d/cron-job
RUN chmod 0644 /etc/cron.d/cron-job && crontab /etc/cron.d/cron-job

# Expose the HTTP port
EXPOSE 8080

# Set the environment variables for MySQL connection
ENV DB_CONNECTION=mysql
ENV DB_HOST=mysql.railway.internal
ENV DB_PORT=3306
ENV DB_DATABASE="railway"
ENV DB_USERNAME="root"
ENV DB_PASSWORD="GfJlypXZmssaVvDTlRkvTkAcTsLzjmZX"

# Set the Apache and PHP configuration (if needed)
RUN echo "upload_max_filesize = 50M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "post_max_size = 50M" >> /usr/local/etc/php/conf.d/uploads.ini && \
    echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/uploads.ini

# Start Apache in the foreground
CMD ["apache2-foreground"]
