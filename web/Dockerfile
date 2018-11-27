FROM ruby:alpine

ENV LANG ja_JP.UTF-8
ENV APP_ROOT /app

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

COPY Gemfile* ${APP_ROOT}/

RUN apk upgrade --no-cache && \
    apk add --update --no-cache \
      bash \
      less \
      tzdata \
      postgresql-client \
      nodejs && \
    apk add --update --no-cache --virtual=build-dependencies \
      build-base \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev && \
    gem install bundler --no-document && \
    bundle install -j4 && \
    apk del build-dependencies

COPY . $APP_ROOT
