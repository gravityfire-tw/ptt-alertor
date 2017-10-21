# building binary
FROM golang:alpine as builder

RUN set -eux; \
	apk add --no-cache --virtual git

ENV GOPATH /go/
ENV GO_WORKDIR $GOPATH/src/github.com/meifamily/ptt-alertor/

WORKDIR $GO_WORKDIR

ADD . $GO_WORKDIR

RUN go get
RUN go install

# building executable image
FROM alpine:latest

RUN set -eux; \
	apk add --no-cache --virtual ca-certificates

COPY config/ config/
COPY public/ public/
COPY --from=builder /go/bin/ptt-alertor .

ENTRYPOINT /ptt-alertor

EXPOSE 9090 6060