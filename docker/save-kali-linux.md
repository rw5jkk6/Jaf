
## Docker imageを保存する
### kaliにインストールするコマンド
- cewl,fping,gobuster,exiftool,ftp,hashcat,netcat,dhclient,dnsutils,tcpdump

- コマンドが入っているかを確認するコマンド
  - `apt list --installed`
  - または
  - `grep "install" /var/log/dpkg.log` 
- コマンドの詳細を知る
  - `apt-cache show パッケージ名` 

### 取得するファイル
- rockyou.txt
  - `/usr/share/wordlists/rockyou.txt`ここに保存する 
- php-reverse-shell
  - `wget https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php` 
- Linpeas
  - `wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -p ~/`

### saveの前にインストールするコマンド
- `apt install -y cewl fping gobuster exiftool ftp hashcat netcat dhclient dnsutils tcpdump`

### imageをcommitする
- 保存するコンテナ名を確認する
- `docker container ls`
- コンテナをイメージで保存する。　`docker container commit コンテナ名 イメージ名`
- `docker container commit kali kali`

### save
- Publicにkali-tarフォルダを作って移動する
- `docker image save -o kali.tar kali`
  - `-o`書き込むファイル名を決める
  - けっこう時間が掛かる

### イメージ全体を削除して掃除する
- ホストにイメージが保存されているので、イメージを一度全部削除する
- `docker image ls -q | xargs docker image rm -f`

### load 
- kaliイメージをロードする
- `docker image load -i kali.tar`
  - `-i` ファイル名を指定してロード

### 確認
- kaliイメージがあるのを確認
- `docker image ls`

## (おまけ)dockerイメージの名前を変えるとき
- `docker tag kali2 kali`
