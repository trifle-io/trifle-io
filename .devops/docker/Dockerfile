# syntax=docker/dockerfile:1

# Minimal image for running the trifle-io docs site
FROM ruby:3.3-alpine

ENV APP_HOME=/app \
    BUNDLER_VERSION=2.3.16 \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development test" \
    RACK_ENV=production \
    APP_ENV=production \
    PORT=8080

WORKDIR $APP_HOME

# Install build tools for native extensions and git for Bundler
RUN apk add --no-cache build-base git

# Install bundler and gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v "$BUNDLER_VERSION" && \
    bundle install --jobs=4 --retry=3

# Copy application code
COPY . .

# Drop privileges for runtime
RUN adduser -D app && chown -R app:app $APP_HOME
USER app

EXPOSE 8080

# Use rackup with Puma via rackup (config.ru sets the app)
CMD ["sh", "-c", "bundle exec rackup -p ${PORT:-8080} -o 0.0.0.0 config.ru"]
