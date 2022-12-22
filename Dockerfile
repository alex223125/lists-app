FROM ruby:3.0.3

RUN mkdir /lists-app

WORKDIR /lists-app

COPY Gemfile /lists-app
COPY Gemfile.lock /lists-app
RUN bundle install

COPY . /lists-app

CMD ["rails", "server", "-b", "0.0.0.0"]