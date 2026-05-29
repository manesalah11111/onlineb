# 1. Use PHP 8.4 to satisfy symfony/css-selector requirement
FROM php:8.4-apache

# 2. Install system tools and libraries for PHP extensions (gd, bcmath, etc.)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Install and enable required PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd bcmath mysqli \
    && docker-php-ext-enable gd bcmath mysqli

# 4. Enable Apache mod_rewrite
RUN a2enmod rewrite

# 5. Get Composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html/

# 6. Copy only composer files first
COPY composer.json composer.lock* ./

# 7. RUN COMPOSER (Added --ignore-platform-reqs as a safety net)
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# 8. Copy the rest of your PHP project files
COPY . .

# Update permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80