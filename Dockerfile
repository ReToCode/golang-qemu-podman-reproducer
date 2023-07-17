FROM golang:1.19-bullseye

ENV BASE=github.com/retocode/golang-qemu-podman-reproducer
WORKDIR ${GOPATH}/src/${BASE}

COPY . .

ENV GOFLAGS="-mod=vendor"
RUN go build $BASE
