FROM instructure/ruby-passenger:2.6

ARG APP_ENV=development

ENV APP_HOME "/usr/src/app/"
ENV APP_ENV "$APP_ENV"

USER root

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y nodejs yarn\
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . $APP_HOME

USER docker

RUN bundle install
RUN yarn install
RUN yarn build

ENTRYPOINT ["./entrypoint.sh"]
