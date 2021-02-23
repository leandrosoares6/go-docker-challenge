# STAGE 1 - Build the binary

FROM golang:alpine AS builder

RUN apk add --no-cache git build-base && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache upx

WORKDIR /go/src
COPY . .

# Build...
RUN go get -d ./ && \
    CGO_ENABLED=0 GOOS=linux go build -o codeeducation -a -ldflags="-s -w" -installsuffix cgo && \
    upx --ultra-brute -qq codeeducation && \
    upx -t codeeducation

# STAGE 2 - Build a small image...

FROM scratch

# Copy our static executable...
COPY --from=builder /go/src/codeeducation .

# Run the codeeducation binary...
ENTRYPOINT ["/codeeducation"]


