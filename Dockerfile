# Use an official Ruby runtime as a parent image
FROM ruby:3.3.0-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl imagemagick libmagickwand-dev ffmpeg

# Install Node.js, Yarn, and PostgreSQL client
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update -qq && apt-get install -y nodejs && \
    npm install -g yarn && \
    apt-get install -y postgresql-client

# Install Dart Sass
RUN npm install -g sass

# Set working directory
WORKDIR /photos_rails

# Add Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --without development test

# Add package.json and yarn.lock
COPY package.json yarn.lock ./

# Install npm packages
RUN yarn install --production

# Copy the current directory contents into the container
COPY . .

# Set production environment variable
ENV RAILS_ENV=production

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Expose port 3000
EXPOSE 3000

# Start server
CMD ["rails", "server", "-b", "0.0.0.0"]
