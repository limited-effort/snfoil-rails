ARG RUBY_VERSION=3.4.3

FROM ruby:${RUBY_VERSION}-slim

RUN apt update && \
    apt install -y --no-install-recommends \
    build-essential \
    libyaml-dev \
    git \
    curl \
    libjemalloc2 \
    libvips \
    pkg-config \
    sqlite3

WORKDIR /workspace

COPY . .

RUN bundle install

CMD ["bundle", "exec", "rspec"]