#!/bin/bash

if [ "$APP_ENV" = "production" ]
then
    ruby web/app.rb
else
    yarn dev
fi