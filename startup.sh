#!/bin/bash

bundle install

color()(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[34m&\e[m,'>&2)3>&1

if [[ $1 == "--live" ]] ; then
  GOVUK_APP_DOMAIN=www.gov.uk \
  GOVUK_WEBSITE_ROOT=https://www.gov.uk \
  PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://www.gov.uk/api} \
  PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk} \
  PLEK_SERVICE_SEARCH_URI=${PLEK_SERVICE_SEARCH_URI-https://www.gov.uk/api} \
  color bundle exec rails s -p 3070 -e production
else
  bundle exec rails s -p 3070
fi
