FROM hashicorp/terraform:0.13.6

RUN mkdir -p /app/my-terraform

WORKDIR /app/my-terraform

ENTRYPOINT ["/bin/sh", "-c", "while true; do echo hello world; sleep 1; done"]
