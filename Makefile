build:
	- docker build -t avnir/php-fpm:php8.1 .

push:
	- docker push avnir/php-fpm:php8.1