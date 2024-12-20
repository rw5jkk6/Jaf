## Docker imageを保存する

### 起動する
- `docker container run --rm -it --name kali-cont kali /bin/bash`
  - 各オプションが何を意味するか必ず調べる 


### kaliにインストールするコマンド
- cewl,fping,gobuster,exiftool,ftp,hashcat,netcat,dnsutils,tcpdump
- nikto

- コマンドが入っているかを確認するコマンド
  - `apt list --installed`
  - または
  - `grep "install" /var/log/dpkg.log` 
- ~コマンドの詳細を知る~
  - ~`apt-cache show パッケージ名`~ 

### 取得するファイル
- rockyou.txt
  - `/usr/share/wordlists/rockyou.txt`ここに保存する 
- php-reverse-shell
  - `wget https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php -p /root/php-reverse-shell.php`
- Linpeas
  - `wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -p /root/linpeas.sh`


### saveの前にインストールするコマンド
- `apt install -y cewl fping gobuster exiftool ftp hashcat netcat-traditional dnsutils tcpdump nikto`

### imageをcommitする
- 新しいターミナルを立ち上げる。ここでdockerから ctrl+d で抜けるとコンテナが削除(--rm)されてしまう
- 保存するコンテナ名(kali-cont)を確認する
- `docker container ls`
- コンテナをイメージで保存する。　`docker container commit コンテナ名 イメージ名`
- `docker container commit kali-cont kali-tmp-img`

### save
- Publicにkali-tarフォルダを作って移動する
- `docker image save -o kali.tar kali-tmp-img`
  - `-o`書き込むファイル名を決める

### イメージ全体を削除して掃除する
- ホストにイメージが保存されているので、イメージを一度全部削除する
- `docker image ls -q | xargs docker image rm -f`

### load 
- kaliイメージをロードする
- `docker image load -i kali.tar`
  - `-i` ファイル名を指定してロード

### 確認
- kaliイメージが1つだけあるのを確認
- `docker image ls`
- dockerを起動してコマンドがあるかを確認する
- `docker container run -it --rm kali-tmp-img /bin/bash`
- `nc`コマンド打つ
- または
- `apt list --installed | grep "netcat"`
  - warningが出るが気にしない、下にnetcat/kali-rollingと表示される

## dockerイメージの名前を変えるとき
- dockerのkali-tmp-imgの名前をkaliに変える、というか名前の異なる同じイメージが２つある
- `docker tag kali-tmp-img kali`
- イメージが２つあるのでkali-tmp-imgを削除する
- `docker image rm kali-tmp-img
  - Untaggedと表示されたら削除されている。なぜdeleteではないかというと、同じイメージに２つの名前がついていただけなので、片方の名前を消したということ 
