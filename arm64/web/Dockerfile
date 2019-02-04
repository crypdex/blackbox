# FROM arm64v8/golang
FROM ubuntu:bionic

RUN apt-get update && apt-get -y upgrade && apt-get install -y golang-go

ADD ./ /go/app
WORKDIR /go/app
ENV PORT=3001
CMD ["go", "run", "main.go"]