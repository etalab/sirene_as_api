#!/bin/sh
set -e
bundle exec rake sunspot:solr:start
exec "$@"
