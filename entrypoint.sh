#!/bin/sh
set -e

# Ensure permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Run migration
echo "Running migrations..."
php artisan migrate --force

# Remove the config:cache command that is causing the crash
# We will skip it for now to get the site live
echo "Starting Apache..."
exec apache2-foreground