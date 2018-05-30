USER_NAME=wildermesser

default: all

all: comment post ui prometheus cloudprober alertmanager telegraf grafana push

push: push-comment push-post push-ui push-prometheus push-cloudprober push-alertmanager push-telegraf push-grafana

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

telegraf:
		docker build -t $(USER_NAME)/telegraf monitoring/telegraf

grafana:
				docker build -t $(USER_NAME)/grafana monitoring/grafana
stackdriver:
				docker build -t $(USER_NAME)/stackdriver monitoring/stackdriver
login:
		docker login -u $(USER_NAME) -p $(DOCKER_PASS)

push-comment: comment login
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

push-telegraf: telegraf login
		docker push $(USER_NAME)/telegraf

push-grafana: grafana login
				docker push $(USER_NAME)/grafana
