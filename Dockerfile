FROM php:8.0

# default-mysql-client for "php artisan db" command (needs "mysql" command of mysql client)
RUN apt-get -y update \
	&& apt-get install -y \
		zlib1g-dev \
		libpng-dev \
		libjpeg-dev \
		libfreetype6-dev \
		libzip-dev \
		libxslt1-dev \
		default-mysql-client \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install bcmath \
		zip \
		xsl \
		mysqli \
		pdo \
		pdo_mysql \
	&& pecl install xdebug \
 	&& docker-php-ext-enable xdebug \
	&& docker-php-source delete
 
# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

WORKDIR /laravel_app

# INSTALL COMPOSER
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/local/bin/composer

# INSTALL NODE + NPM
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | \
	apt-get install -y nodejs \
						npm

VOLUME [ "/laravel_app" ]

CMD ["php","artisan","serve", "--host=0.0.0.0", "--port=8000"]
EXPOSE 8000