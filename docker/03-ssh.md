## ParrotOSからDockerのwordpressにsshで接続する
### docker側の設定
- compose.yamlのPorts:のところに`2222:22`追加。これは外部に対してportを解放するため。ここでは2222番でアクセスできるのを意味している
```
- "8080:80"
- "2222:22"
```
- コンテナを立ち上げて接続
  - `docker compose up -d`
  - `docker container exec コンテナ名 /bin/bash`
  - 多分コンテナ名こんなん`wordpress-wordpreww-1`

### コンテナ接続後
- `apt update`
- `apt install openssh-server vim`
  - openssh-serverがsshを受ける側でインストールする必要なもの 
- passwordの設定。パスワードはdragonにする。dockerのubuntuでは基本的にはrootのパスワードは設定されていないので、ここで設定する
  - `passwd`
- vimで/etc/ssh/sshd_configを次のを書き換える。コメントを消してyesにしたりする
```
PermitRootLogin yse
PasswordAuthentication yes
```
- sshを起動する
  - `service ssh start`
 
### PowerShellでWindowsのアドレスを調べる
- `ipconfig`
- 192.168.*.*が2個くらい出てくるので、両方メモっておく。多分,192.168.56.*の方

### ParrotOSのターミナルからコンテナにsshする
- `ssh -p2222 root@192.168.56.*`

### hydraしてみる
- `hydra -l root -P /usr/share/wordlists/rockyou.txt ssh://192.168.56.*:2222`
