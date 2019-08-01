FROM python:3.7.4-slim-stretch

RUN apt-get update && \
  apt-get install git build-essential -y && \
  git clone https://github.com/dashpay/sentinel.git && \
  cd sentinel && \
  pip3 install -r requirements.txt

COPY sentinel.conf /sentinel/