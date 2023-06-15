build:
	- docker build -t avnir/php-fpm:php8.2 .

push:
	- docker push avnir/php-fpm:php8.2