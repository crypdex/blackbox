#!/usr/bin/env bash

GOARCH=amd64 GOOS=darwin go build -o ./bin/darwin/app main.go
GOARCH=arm64 GOOS=linux go build -o ./bin/arm64/app main.go
GOARCH=amd64 GOOS=linux go build -o ./bin/amd64/app main.go