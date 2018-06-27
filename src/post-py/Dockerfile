FROM alpine:latest
RUN apk update && apk add python3 gcc musl-dev python3-dev

WORKDIR /app
ADD . /app

RUN pip3 install -r /app/requirements.txt

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]
