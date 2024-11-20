# Use the official PHP image with Apache and the correct PHP version
FROM php:8.1-apache

# Install system dependencies for PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    git \
    curl \
    libicu-dev \
    zlib1g-dev \
    libxslt1-dev \
    libexif-dev \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    pdo_mysql \
    zip \
    exif \
    && docker-php-ext-enable exif

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy the current directory contents into the container
COPY . .

# Install Composer dependencies, ignoring the ext-exif platform requirement
RUN composer install --no-dev --optimize-autoloader --prefer-dist --ignore-platform-req=ext-exif

# Expose port 80 for the web server
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
