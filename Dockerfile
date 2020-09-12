# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y nodejs && \
    curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.5.3 --force && \
    mix local.rebar --force

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

RUN npm install
# RUN node node_modules/brunch/bin/brunch build

# RUN cd assets && npm install
# Install hex package manager
RUN mix local.hex --force

# Compile the project
RUN mix deps.get

CMD ["bash", "/app/entrypoint.sh"]
