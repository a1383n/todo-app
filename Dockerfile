FROM shinsenter/laravel:php8.3-alpine

WORKDIR /var/www/html

RUN apk add --no-cache nodejs npm

COPY composer.json composer.lock ./

RUN --mount=type=cache,target=/root/.composer/cache \
    composer install \
        --no-dev \
        --prefer-dist \
        --no-interaction \
        --no-progress \
        --optimize-autoloader

COPY package.json package-lock.json ./

RUN --mount=type=cache,target=/root/.npm npm ci

COPY --chown=$APP_USER:$APP_GROUP . .

RUN composer dump-autoload --optimize

RUN npm run build
