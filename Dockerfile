# STAGE 1 - Build the binary

FROM golang:alpine AS builder

WORKDIR /go/src
COPY . .

# Build...
RUN go install example.com/leandrosnowdev/codeeducation

# STAGE 2 - Build a small image...

FROM scratch

# Copy our static executable...
COPY --from=builder /go/bin/codeeducation /go/bin/codeeducation

# Run the codeeducation binary...
ENTRYPOINT ["/go/bin/codeeducation"]


