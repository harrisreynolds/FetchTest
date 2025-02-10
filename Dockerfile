# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t fetch_test .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name fetch_test fetch_test

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    SECRET_KEY_BASE="b2a9d105aec898b0a895039f45762c7e54e0c1946e3871ff1b019ffbe3d1741a6a2ce21df9dd577f6ef86b99f1f33df3981fc774e51e4e57988e72d8c440a833" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
    bundle config set --local without 'development test' && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/thrust", "./bin/rails", "server"]
