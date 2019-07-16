ARG dist=stretch
ARG version=1.12

FROM golang:$version-$dist AS builder

ENV github_token=a843d6e97c67943069f5e7a614dfd7f33ef29edf

RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes zip \
    && git config --global url."https://${github_token}:@github.com".insteadOf "https://github.com" \
    && mkdir -p $HOME/.ssh && /bin/echo "StrictHostKeyChecking no " > $HOME/.ssh/config

WORKDIR /build

COPY . .

RUN make setup
RUN make test
RUN make build

FROM alpine:3.9
WORKDIR /app

RUN apk --update upgrade \
  && apk add --no-cache ca-certificates \
  && update-ca-certificates \
  && rm -rf /var/cache/apk/*

COPY --from=builder /build/{{$.Application}} /app/{{$.Application}}

ENTRYPOINT ["/app/{{$.Application}}"]