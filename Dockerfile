FROM golang:1.13 AS builder
WORKDIR /app
COPY main.go go.mod ./
RUN CGO_ENABLED=0 GOOS=linux go build -o lb .

FROM alpine:latest
ENV backends "http://localhost:6379"
RUN apk --no-cache add ca-certificates
WORKDIR /root
COPY --from=builder /app/lb .
CMD "/root/lb" -backends=${backends}