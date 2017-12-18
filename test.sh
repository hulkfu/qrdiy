#!/bin/bash

case $1 in
  js)
  cmd="bundle exec rake spec:javascript"
  ;;
  *)
  echo "What test?"
  ;;
esac

echo "run: $cmd"
$cmd $2
