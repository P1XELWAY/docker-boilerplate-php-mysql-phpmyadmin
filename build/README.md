#<ins>Docker Configuration</ins>

###Example of ***'docker-compose.yml'***

```
# https://hub.docker.com/r/actency/docker-apache-php/
# docker exec -it vevgdocker_web_1 sh
# sudo ifconfig en0 alias 10.254.254.254 255.255.255.0
# https://docs.docker.com/compose/compose-file
version: '3.1'
services:
  # database container - actency images
  database:
    # actency/docker-mysql available tags: latest, 5.7, 5.6, 5.5
    image: actency/docker-mysql:5.7
    ports:
      - "3306:3306"
    env_file:
      - ./build/env

  # actency/docker-apache-php available tags: latest, 7.1, 7.0, 5.6, 5.5, 5.4, 5.3
  web:
    image: actency/docker-apache-php:7.1
    ports:
      - "3000:80"
    links:
      - database:mysql
    build:
      context: .
      dockerfile: ./Dockerfile
    volumes:
      - ./www:/var/www/html
      - "./build/php.ini:/usr/local/etc/php/php.ini"
    tty: true

  # phpmyadmin container - actency images
  phpmyadmin:
    image: actency/docker-phpmyadmin
    ports:
      - "8000:80"
    env_file:
      - ./build/env
    links:
      - database:mysql
```

###Example of ***'php.ini'***

```
; timezone
;date.timezone = Asia/Tokyo

; error reporing
;log_errors = On
;error_log = /var/log/php.log

; xdebug
[XDebug]
zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so ; for PHP 7
;zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so ; for PHP 5
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.remote_connect_back = 0
xdebug.remote_host = 10.254.254.254
xdebug.idekey = XDEBUG_ECLIPSE
xdebug.remote_log = /var/www/html/xdebug.log
```

###Example of ***'Dockerfile'***
```
FROM php:7.1-apache
RUN apt-get update 
RUN apt-get install -y nmap telnet
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev libbz2-dev nmap telnet
# RUN docker-php-ext-install mcrypt && docker-php-ext-enable mcrypt
# RUN docker-php-ext-install bz2 && docker-php-ext-enable bz2
# RUN docker-php-ext-install calendar && docker-php-ext-enable calendar
# RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
# RUN docker-php-ext-install dba && docker-php-ext-enable dba
# RUN docker-php-ext-install exif && docker-php-ext-enable exif
# RUN docker-php-ext-install gd && docker-php-ext-enable gd
# RUN docker-php-ext-install gettext && docker-php-ext-enable gettext
# RUN docker-php-ext-install mysql && docker-php-ext-enable mysql
# RUN docker-php-ext-install pdo && docker-php-ext-enable pdo
# RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

RUN yes | pecl install xdebug # for PHP 7
# RUN yes | pecl install xdebug-2.5.0 * for PHP 5

WORKDIR /var/www/app/

EXPOSE 80 443
```

###To install extension in the ***'Dockerfile'*** add this line with selected extension :

RUN docker-php-ext-install **extension name** && docker-php-ext-enable **extension name**

###For install different version of php in ***'Dockerfile'*** 

FROM php:7.1-apache
FROM php:5.6-apache

###Possible values for ext-name:

bcmath
bz2
calendar
ctype
curl
dba
dom
enchant
exif
fileinfo
filter
ftp
gd
gettext
gmp
hash
iconv
imap
interbase
intl
json
ldap
mbstring
mcrypt
mysqli
oci8
odbc
opcache
pcntl
pdo
pdo_dblib
pdo_firebird
pdo_mysql
pdo_oci
pdo_odbc
pdo_pgsql
pdo_sqlite
pgsql
phar
posix
pspell
readline
recode
reflection
session
shmop
simplexml
snmp
soap
sockets
spl
standard
sysvmsg
sysvsem
sysvshm
tidy
tokenizer
wddx
xml
xmlreader
xmlrpc
xmlwriter
xsl
zip