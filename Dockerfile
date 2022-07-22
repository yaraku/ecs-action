# Container image that runs your code
FROM php:8.0-alpine

RUN apk add --no-cache tini git openssh-client jq php8.0-intl

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME="/composer" \
    composer global config minimum-stability dev

RUN COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME="/composer" \
    composer global require symplify/easy-coding-standard --prefer-dist --no-progress --dev

ENV PATH /composer/vendor/bin:${PATH}

RUN mkdir /app && ln -s /composer/vendor/ /app/vendor

# Add entrypoint script

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Package container

WORKDIR "/app"
ENTRYPOINT ["/entrypoint.sh"]