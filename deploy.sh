#!/bin/bash

export HUGO_ENV=production 
hugo \
  --minify \
  --noTimes \
  --baseURL "https://mrchoke.org/" \
  && \
rsync -avz --delete --compress public/ mrchoke@mrchoke.org:web/html/
