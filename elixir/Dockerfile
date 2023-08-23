FROM elixir:1.14 AS builder

ARG USER_ID
ARG GROUP_ID

EXPOSE 4000

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools

# Add an api_user so files created are not owned by root
RUN groupadd -g ${GROUP_ID} api_user
RUN useradd -l -m -u ${USER_ID} -g api_user -s /bin/bash api_user && su api_user -c 'mkdir -p /home/api_user/app'
USER api_user

WORKDIR /home/api_user/app

RUN mix local.hex --force && mix local.rebar --force

# Install dependencies so the image is ready to go
COPY --chown=api_user:api_user mix.exs mix.lock ./
RUN mix deps.get
RUN mix deps.compile


######################################################
FROM alpine:latest  
RUN apk --no-cache add ca-certificates postgresql-client inotify-tools
WORKDIR /home/api_user/app
COPY --from=builder /home/api_user/app ./
CMD ["./app"]  
