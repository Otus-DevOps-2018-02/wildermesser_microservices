$(USER_NAME)=wildermesser

default: all

all: comment post ui prometheus cloudprober push

push: push-comment push-post push-ui push-prometheus push-cloudprober

comment:
		cd src/comment && sh docker_build.sh

post:
		cd src/post-py && sh docker_build.sh

ui:
		cd src/ui && sh docker_build.sh

prometheus:
		docker build -t $(USER_NAME)/prometheus monitoring/prometheus

cloudprober:
		docker build -t $(USER_NAME)/cloudprober monitoring/cloudprober

login: 
		docker login -u $(USER_NAME) -p $(DOCKER_PASS)

push-comment: login
		docker push $(USER_NAME)/comment

push-post: login
		docker push $(USER_NAME)/post

push-ui: login
		docker push $(USER_NAME)/ui

push-prometheus: login
		docker push $(USER_NAME)/prometheus

push-cloudprober: login
		docker push $(USER_NAME)/cloudprober
