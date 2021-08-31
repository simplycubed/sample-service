FROM golang:latest as base
WORKDIR /app
ENV GO111MODULE=on
ENV	CGO_ENABLED=0
ENV	GOOS=linux
ENV	GOARCH=amd64
COPY . .
RUN  go build -v -o app

FROM scratch as app
COPY --from=base app /

RUN useradd -ms /bin/bash 1001 nonroot
USER nonroot

EXPOSE 8080
CMD ["/app"]