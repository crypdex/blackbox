FROM golang:alpine

ADD ./ /go/app
WORKDIR /go/app
ENV PORT=3001
CMD ["go", "run", "main.go"]