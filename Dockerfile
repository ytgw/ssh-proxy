FROM ubuntu:22.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        # SSH関係のパッケージ
        openssh-client connect-proxy \
        # プロキシ確認用のcurl関連のパッケージ
        curl ca-certificates

COPY ssh-config.txt /root/.ssh/config
