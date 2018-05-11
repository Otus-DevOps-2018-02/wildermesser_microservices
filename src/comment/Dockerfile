FROM alpine:latest AS build
RUN apk update && apk add ruby ruby-dev ruby-bundler build-base


WORKDIR /tmp
ADD Gemfile* /tmp/
RUN bundle install --deployment --binstubs=./bin

FROM alpine:latest
RUN apk update && apk add ruby ruby-bundler

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY --from=build /tmp/vendor /app/vendor
COPY --from=build /tmp/bin /app/bin
ADD . $APP_HOME

ENV PATH /app/bin:$PATH
ENV GEM_PATH=/app/vendor/bundle/ruby/2.4.0/:$GEM_PATH

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
