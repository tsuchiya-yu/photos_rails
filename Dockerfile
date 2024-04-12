# syntax=docker/dockerfile:1

# Use an official Ruby runtime as a parent image
FROM ruby:3.3.0-slim

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl

# Install Node.js and PostgreSQL client
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs postgresql-client

# Install Yarn
RUN npm install -g yarn

# Set working directory
WORKDIR /photos_rails

# Add Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Add package.json and yarn.lock
COPY package.json yarn.lock ./

# Install npm packages
RUN yarn install

# Copy the current directory contents into the container
COPY . .

# Define environment variable
ENV RAILS_ENV=development

# Expose port 3000
EXPOSE 3000

# Start server using bin/dev
CMD ["./bin/dev"]
