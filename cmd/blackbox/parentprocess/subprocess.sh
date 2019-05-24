#!/usr/bin/env bash


docker run -it -v /Volumes/T5/data/decred/dcrwallet:/home/decred/.dcrwallet crypdex/decred dcrwallet --create

##!/bin/bash
#
#echo "Enter some text:"
#read -r input
#echo "you typed: $input"