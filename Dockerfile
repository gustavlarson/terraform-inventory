FROM golang as build

WORKDIR /go/src/github.com/adammck/terraform-inventory
RUN git clone https://github.com/adammck/terraform-inventory.git .

RUN go get ./...
RUN go build .

FROM registry.gitlab.com/gitlab-org/terraform-images/stable:latest as gitlab-terraform

FROM alpine:latest

COPY --from=build /go/src/github.com/adammck/terraform-inventory/terraform-inventory /usr/local/bin/terraform-inventory
COPY --from=gitlab-terraform /usr/bin/gitlab-terraform /usr/local/bin/gitlab-terraform
COPY --from=gitlab-terraform /usr/bin/tfplantool /usr/local/bin/tfplantool

RUN apk add --no-cache ansible python3 openssh coreutils terraform jq
