build:
	- docker build -t avnir/php-fpm:php7.4 .

push:
	- docker push avnir/php-fpm:php7.4