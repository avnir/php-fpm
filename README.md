# php-fpm docker image

This is a [Docker](http://www.docker.com) image using [PHP-FPM](http://php-fpm.org/).


## Versions
- [latest|php7.2](https://github.com/avnir/php-fpm/tree/master) available as ```avnir/php-fpm:latest``` at [Docker Hub](https://hub.docker.com/r/avnir/php-fpm/)
- [php7.0](https://github.com/avnir/php-fpm/tree/php7.0) available as ```avnir/php-fpm:latest``` at [Docker Hub](https://hub.docker.com/r/avnir/php-fpm/)
- [php5](https://github.com/avnir/php-fpm/tree/php5) available as ```avnir/php-fpm:php5``` at [Docker Hub](https://hub.docker.com/r/avnir/php-fpm/)


## Usage examples
- ```docker run -d -v $PWD:/var/www/ avnir/php-fpm:latest -p 9000:9000```
- ```docker run -d --name php -v $PWD:/var/www/ avnir/php-fpm:latest -p 9000:9000```
- ```docker run --rm -ti -v $PWD:/var/www/ avnir/php-fpm:latest -p 9000:9000```


## Contributing

Fork -> Patch -> Push -> Pull Request


## Author

* [Avni Rexhepi](https://github.com/avnir)


## License

Apache License