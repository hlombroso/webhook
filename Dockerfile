#########################################
# Build stage
#########################################
FROM golang:alpine3.14 AS builder

# Artifact name
ARG ARTIFACT=webhookd

# Copy sources into the container
ADD . /go/src/$ARTIFACT

# Set working directory
WORKDIR /go/src/$ARTIFACT

# Build the binary
ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64
RUN go build \
    -o /go/bin/$ARTIFACT \
    -ldflags '-s -w'

#########################################
# Distribution stage
#########################################
# FROM docker:dind as runner
FROM alpine:3.14.2 as  runner

# Artifact name
ARG ARTIFACT=webhookd

RUN apk update

# Install bash
RUN apk add --no-cache bash

# install docker
# RUN apk add docker
RUN apk add --no-cache docker-cli

# Create folder structure
RUN mkdir -p /var/opt/webhookd/scripts

# Install binary and default scripts
COPY --from=builder /go/bin/$ARTIFACT /usr/local/bin/$ARTIFACT
# COPY --from=builder /go/src/$ARTIFACT/scripts /var/opt/webhookd/scripts

WORKDIR /var/opt/webhookd

EXPOSE 9000

# Define command
# CMD $ARTIFACT

ENTRYPOINT [ "webhookd" ]