# Build Stage
FROM golang:1.16.2 AS build-stage

LABEL app="cookie"
LABEL REPO="https://github.com/tonyb983/cookie"

ENV PROJPATH=/go/src/github.com/tonyb983/cookie

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN apt update \
 && apt install tree -y --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

ADD . /go/src/github.com/tonyb983/cookie
WORKDIR /go/src/github.com/tonyb983/cookie

RUN echo "Workdir added to docker image."
RUN tree .
RUN sleep 3

RUN make build-alpine

RUN echo "After build:"
RUN tree .
RUN sleep 3

# Final Stage
FROM golang:1.16.2

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/tonyb983/cookie"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/cookie/bin

RUN apt update \
 && apt install dumb-init -y --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/cookie/bin

COPY --from=build-stage /go/src/github.com/tonyb983/cookie/bin/cookie /opt/cookie/bin/
RUN chmod +x /opt/cookie/bin/cookie

# Create a user 'appuser' under 'xyzgroup'
#RUN adduser -D -g '' cookie
#RUN adduser -S --disabled-password --no-create-home cookie cookiegroup
RUN useradd --user-group --no-create-home --shell /usr/bin/bash --no-log-init  cookie

# Chown all the files to the app user.
RUN chown -R cookie:cookie /opt/cookie/bin

# Switch to 'cookie'
USER cookie

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/cookie/bin/cookie"]
