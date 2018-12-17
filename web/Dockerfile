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
      postgresql-dev \
      git \
      openssl \
      curl \
      sudo && \
    # bundle install
    gem install bundler --no-document && \
    bundle install -j4 && \
    # install mecab
    cd /tmp && \
    git clone --depth 1 https://github.com/taku910/mecab.git && \
    cd /tmp/mecab/mecab && \
    ./configure --enable-utf8-only --with-charset=utf8 && \
    make -j ${CPUCOUNT} && \
    make install && \
    # intall neologd
    cd /tmp && \
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n -y && \
    # clean up
    apk del build-dependencies && \
    rm -rf /tmp/mecab*

COPY . $APP_ROOT
