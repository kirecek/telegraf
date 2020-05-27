FROM golang as builder
RUN mkdir /build 
WORKDIR /build 
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-w -s" -a -installsuffix cgo -o telegraf ./cmd/telegraf

FROM alpine
RUN apk add ca-certificates
RUN mkdir -p /etc/telegraf/telegraf.d/
COPY --from=builder /build/telegraf /usr/bin/telegraf
CMD ["telegraf", "--config-directory", "/etc/telegraf/telegraf.d/"]
