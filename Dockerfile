FROM golang:1.16.5-alpine3.13 AS BUILD

# RUN apk add gcc build-base

ENV LOG_LEVEL 'info'

#endpoint: http, lambda
ENV ENDPOINT 'lambda'

WORKDIR /app

ADD /go.mod /app/
ADD /go.sum /app/

RUN go mod download

ADD /main.go /app/

# RUN go test -v -p 1
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /bin/http-lambda-bridge

FROM scratch
COPY --from=BUILD /bin/http-lambda-bridge /bin/http-lambda-bridge