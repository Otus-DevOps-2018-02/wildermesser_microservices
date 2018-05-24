FROM docker:latest
RUN apk update \
  && apk add curl openssh-client \
  && curl -s -o terraform.zip https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
  && unzip -q terraform.zip -d /bin
