FROM alpine:latest
RUN apk update && apk add ruby ruby-dev ruby-bundler build-base

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME
RUN bundle install 
CMD ["puma"]
