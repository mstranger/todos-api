# syntax=docker/dockerfile:1

FROM ruby:3.2-slim

# build-essential, gnupg2, less, git, libpq-dev,
# postgresql-client, libvips, curl

RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends \
    build-essential \
    libpq-dev \
    libvips

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR /app

COPY . ./

RUN bundle update --bundler

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
