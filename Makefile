USER_NAME=wildermesser

default: all

all: comment post ui prometheus cloudprober alertmanager push 

push: push-comment push-post push-ui push-prometheus push-cloudprober push-alertmanager

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

alertmanager:
		docker build -t $(USER_NAME)/alertmanager monitoring/alertmanager

login: 
		docker login -u $(USER_NAME) -p $(DOCKER_PASS)

push-comment: commet login
		docker push $(USER_NAME)/comment

push-post: post login
		docker push $(USER_NAME)/post

push-ui: ui login
		docker push $(USER_NAME)/ui

push-prometheus: prometheus login
		docker push $(USER_NAME)/prometheus

push-cloudprober: cloudprober login
		docker push $(USER_NAME)/cloudprober

push-alertmanager: alertmanager login
		docker push $(USER_NAME)/alertmanager
