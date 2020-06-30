#! /bin/sh

dropdb bristlecone_development
createdb bristlecone_development
heroku local:run rake db:migrate
heroku local:run rake db:seed
