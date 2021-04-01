FROM golang as build

WORKDIR /go/src/github.com/adammck/terraform-inventory
RUN git clone https://github.com/adammck/terraform-inventory.git .
#RUN cd terraform-inventory
#ADD terraform-inventory .

RUN go get ./...
RUN go build .

FROM alpine:latest

COPY --from=build /go/src/github.com/adammck/terraform-inventory/terraform-inventory /usr/local/bin/terraform-inventory

RUN apk add --no-cache ansible python3 openssh coreutils terraform
