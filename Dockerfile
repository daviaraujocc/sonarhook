FROM golang:1.17 as builder

WORKDIR /workspace

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download


COPY main.go main.go
COPY config/ config/
COPY controller/ controller/
COPY message/ message/

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o sonarhook main.go

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/sonarhook .
USER 65532:65532

ENTRYPOINT ["/sonarhook"]