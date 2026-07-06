ARG RUBY_VERSION=3.4.3

FROM ruby:${RUBY_VERSION}-slim

RUN apt update && \
    apt install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libjemalloc2 \
    libvips \
    libyaml-dev \
    openssh-client \
    pkg-config \
    sqlite3

WORKDIR /workspace

COPY . .

RUN bundle install

CMD ["bundle", "exec", "rspec"]