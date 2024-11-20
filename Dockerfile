# Step 1: Use the official PHP image with Apache
FROM php:8.0-apache

# Step 2: Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Step 3: Enable Apache mod_rewrite for Laravel's routing
RUN a2enmod rewrite

# Step 4: Set the working directory inside the container
WORKDIR /var/www/html

# Step 5: Copy the Laravel project files into the container
COPY . .

# Step 6: Install Composer (PHP package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Step 7: Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Step 8: Set the correct file permissions for Laravel directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Step 9: Expose the container's port 80 (used by Apache)
EXPOSE 80

# Step 10: Start Apache in the foreground
CMD ["apache2-foreground"]
