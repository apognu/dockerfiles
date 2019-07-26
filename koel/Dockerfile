FROM php:7.3-apache-buster as builder

ARG KOEL_VERSION_REF=v3.7.2
ARG COMPOSER_VERSION=1.1.2
ARG NODE_VERSION=node_8.x

RUN apt-get update && apt-get install -y gnupg2 apt-transport-https git libxml2-dev zlib1g-dev libcurl4-openssl-dev && \
    curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/${NODE_VERSION} stretch main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/${NODE_VERSION} stretch main" | tee --append /etc/apt/sources.list.d/nodesource.list && \
    curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && \
	  chmod +x /usr/local/bin/composer && \
    docker-php-ext-install zip mbstring curl xml

USER www-data

RUN curl -sL https://github.com/phanan/koel/archive/v3.7.2.tar.gz > /tmp/koel.tar.gz && \
    tar zxf /tmp/koel.tar.gz -C /tmp

RUN git clone https://github.com/phanan/koel -b ${KOEL_VERSION_REF} /tmp/koel
WORKDIR /tmp/koel

RUN composer install && \
    yarn install

FROM php:7.2.0-apache-stretch

ARG RUNTIME_DEPS="\
  libcurl4-openssl-dev \
  zlib1g-dev \
  libxml2-dev \
  faad \
  ffmpeg"

ARG PHP_RUNTIME_DEPS="\
  mbstring \
  curl \
  xml \
  zip \
  pdo \
  pdo_mysql \
  exif"

# Install dependencies.
RUN apt-get update && apt-get install --yes ${RUNTIME_DEPS} && \
    docker-php-ext-install ${PHP_RUNTIME_DEPS} && \
    apt-get clean

COPY --from=builder /tmp/koel /var/www/html
COPY ./.htaccess /var/www/html

RUN rm /var/www/html/.env && \
    chown -R www-data:www-data /var/www/html && \
    a2enmod rewrite

COPY koel /usr/local/bin/

ENTRYPOINT ["koel"]
CMD ["apache2-foreground"]

EXPOSE 80
