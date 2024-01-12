FROM ubuntu:22.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        # sshコマンド
        openssh-client \
        # connect-proxyコマンド
        connect-proxy \
        # ncコマンド
        netcat \
        # プロキシ確認用のcurl関連のパッケージ
        curl ca-certificates

COPY ssh-config.txt /root/.ssh/config
