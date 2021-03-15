# Build Stage
FROM golang:1.16.2 AS build-stage

LABEL app="build-cookie"
LABEL REPO="https://github.com/tonyb983/cookie"

ENV PROJPATH=/go/src/github.com/tonyb983/cookie

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/tonyb983/cookie
WORKDIR /go/src/github.com/tonyb983/cookie

RUN make build-alpine

# Final Stage
FROM alpine:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/tonyb983/cookie"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/cookie/bin

WORKDIR /opt/cookie/bin

COPY --from=build-stage /go/src/github.com/tonyb983/cookie/bin/cookie /opt/cookie/bin/
RUN chmod +x /opt/cookie/bin/cookie

# Create appuser
RUN adduser -D -g '' cookie
USER cookie

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/cookie/bin/cookie"]
