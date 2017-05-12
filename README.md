# php-fpm docker image

This is a [Docker](http://www.docker.com) image using [PHP-FPM](http://php-fpm.org/).


## Versions
- [latest](https://github.com/avnir/php-fpm/tree/master) available as ```avnir/php-fpm:latest``` at [Docker Hub](https://hub.docker.com/r/avnir/php-fpm/)
- [php5](https://github.com/avnir/php-fpm/tree/php5) available as ```avnir/php-fpm:php5``` at [Docker Hub](https://hub.docker.com/r/avnir/php-fpm/)


## Usage examples
- ```docker run -d -v $PWD:/var/www/ avnir/php-fpm -p 9000:9000```
- ```docker run -d --name phpfpm -v $PWD:/var/www/ avnir/php-fpm -p 9000:9000```
- ```docker run --rm -ti -v $PWD:/var/www/ avnir/php-fpm -p 9000:9000```


## Contributing

Fork -> Patch -> Push -> Pull Request


## Authors

* [Avni Rexhepi](https://github.com/avnir)


## License

Apache License


## Copyright

```
Copyright (c) 2016 Avni Rexhepi <http://www.avnirexhepi.com>
```