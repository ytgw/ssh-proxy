# ssh-proxy

プロキシ環境下で[TCP exposer](https://www.tcpexposer.com/)が使えようにする。
プロキシの

## 環境構築

検証環境がわかりやすいようにDockerを使った。

```bash
docker compose build
docker compose run --rm app
```

## SSH接続

下記コマンドで接続できる。

```bash
ssh -o "ProxyCommand connect-proxy -H http_user@http_proxy.example.com:8080 %h %p" anonymous@tcpexposer.com
```

## SSH Config

SSHの設定ファイルを[こちら](ssh-config.txt)とした場合は、下記コマンドで接続できる。
設定ファイルは通常```~/.ssh/config```というパスに配置する。

```bash
ssh TCPExposer
```

## 参考WEBサイト

- [SSHを駆使して数々の試練（プロキシ、踏み台）を乗り越える話](https://qiita.com/u-koji/items/c23c06ef594e34655666)
- [LinuxでHTTP proxy越しにSSHする](https://ymotongpoo.hatenablog.com/entry/20110325/1301039272)
