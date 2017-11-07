FROM ruby:2.3.1
RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential nodejs && apt-get clean

# for capybara-webkit
RUN apt-get update -qq && apt-get install -y libqt4-webkit libqt4-dev xvfb

ENV GOVUK_APP_NAME collections-frontend
ENV GOVUK_ASSET_ROOT http://assets-origin.dev.gov.uk
ENV PORT 3070
ENV RAILS_ENV development

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* .ruby-version $APP_HOME/
RUN bundle install
ADD . $APP_HOME

CMD bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p $PORT -b '0.0.0.0'"
