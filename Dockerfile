FROM golang as builder
RUN mkdir /build 
ADD . /build/
WORKDIR /build 
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-w -s" -a -installsuffix cgo -o telegraf ./cmd/telegraf

FROM alpine
RUN apk add ca-certificates
COPY --from=builder /build/telegraf .
CMD ["./telegraf"]
