# This Dockerfile is only used for development

FROM golang:stretch as build-env
# All these steps will be cached
RUN mkdir /hello
WORKDIR /hello
# <- COPY go.mod and go.sum files to the workspace
COPY go.mod .
COPY go.sum .

# Get dependancies - will also be cached if we won't change mod/sum
RUN go mod download
# COPY the source code as the last step
COPY . .

RUN apt-get update && apt-get install apt-transport-https
RUN echo "deb [trusted=yes] https://apt.fury.io/crypdex/ /" > /etc/apt/sources.list.d/fury.list

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/hello
# <- Second step to build minimal image
#FROM scratch
#COPY --from=build-env /go/bin/hello /go/bin/hello
ENTRYPOINT ["/go/bin/hello"]