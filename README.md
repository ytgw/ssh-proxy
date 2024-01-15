# ssh-proxy

プロキシ環境下で[TCP exposer](https://www.tcpexposer.com/)が使えようにする。


## 環境構築

検証環境がわかりやすいようにDockerを使った。

```bash
docker compose up -d --build
docker compose exec app bash
```


## SSH接続方法

下記コマンドで接続できる。
ただし、 proxy_user, proxy.example.com, proxy_port, ssh_user, ssh.example.com は自分の環境に合わせる

```bash
ssh -o "ProxyCommand connect-proxy -H proxy_user@proxy.example.com:proxy_port %h %p" ssh_user@ssh.example.com
```

もしくは、下記のような設定ファイル(```~/.ssh/config```)を準備した上で```ssh Foo```のコマンドで接続する。
```
Host Foo
    HostName ssh.example.com
    User ssh_user
    ProxyCommand connect-proxy -H proxy_user@proxy.example.com:proxy_port %h %p
```


## 検証環境での接続方法

SSH接続先をTCP Exposer、プロキシを検証用に立てたSquidサーバーの場合は下記で接続できる。

```bash
# プロキシの確認のため、SSHでなくHTTP/HTTPSで接続できるか確認する
curl --proxy http://proxy:3128 http://www.tcpexposer.com
curl --proxy http://proxy:3128 https://www.tcpexposer.com

# SSH接続の確認(connect-proxyを使う場合)
ssh -o "ProxyCommand connect-proxy -H proxy:3128 %h %p" -R 80:localhost:8080 anonymous@tcpexposer.com

# SSH接続の確認(ncを使う場合)
ssh -o "ProxyCommand nc -X connect -x proxy:3128 %h %p" -R 80:localhost:8080 anonymous@tcpexposer.com

# 設定ファイルを使った接続
ssh -R 80:localhost:8080 TCPExposer
```

なお、設定ファイル(```~/.ssh/config```)は[こちら](ssh-config.txt)のとおりである。


## 通信パケットの取得

```bash
docker compose up -d --build

# TCPサーバーの起動
# 一回受け取るとプロセスは終了する
docker compose exec app nc -l 8080

# SSH接続
docker compose exec app ssh -o "ProxyCommand connect-proxy -H proxy:3128 %h %p" -R 80:localhost:8080 anonymous@tcpexposer.com
docker compose exec app ssh -o "ProxyCommand nc -X connect -x proxy:3128 %h %p" -R 80:localhost:8080 anonymous@tcpexposer.com

# パケット取得
docker compose exec app tcpdump -i any -w /data/$(date "+%Y-%m-%d-%H-%M-%S").pcapng
```


## 参考WEBサイト

- [SSHを駆使して数々の試練（プロキシ、踏み台）を乗り越える話](https://qiita.com/u-koji/items/c23c06ef594e34655666)
- [LinuxでHTTP proxy越しにSSHする](https://ymotongpoo.hatenablog.com/entry/20110325/1301039272)
