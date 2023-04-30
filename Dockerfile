# syntax=docker/dockerfile:1

FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    git \
    libvips \
    curl

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=C.UTF-8

WORKDIR /app

COPY . ./

RUN bundle update --bundler && bundle install

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
