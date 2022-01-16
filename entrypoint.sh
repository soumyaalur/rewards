#!/bin/bash

bundle install && bundle exec rails db:drop db:create db:migrate db:seed

bundle exec rails s -b 0.0.0.0