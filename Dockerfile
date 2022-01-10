ARG PROJECT_ID

FROM gcr.io/$PROJECT_ID/golang:latest AS base
WORKDIR /app
ENV GO111MODULE=on
ENV	CGO_ENABLED=0
ENV	GOOS=linux
ENV	GOARCH=amd64
COPY . .
RUN  go build -v -o app

FROM alpine:latest as certs
RUN apk --update add ca-certificates

FROM scratch as app
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/certificates.crt
COPY --from=base app /
ADD passwd.minimal /etc/passwd
USER nonroot

EXPOSE 8080
CMD ["/app"]
