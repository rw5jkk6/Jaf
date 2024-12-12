## Docker imageを保存する
### kaliにインストールするコマンド
- cewl,fping,gobuster,exiftool,ftp,hashcat

- コマンドが入っているかを確認するコマンド
  - `apt list --installed`
  - または
  - `grep "install" /var/log/dpkg.log` 
- コマンドの詳細を知る
  - `apt-cache show パッケージ名` 

### 取得するファイル
- rockyou.txt
- php-reverse-shell
  - `wget https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php` 
- Linpeas
  - `wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -p ~/`

### saveの前にインストールするコマンド
- `apt install -y cewl fping gobuster exiftool ftp hashcat`

### imageをcommitする
- 保存するコンテナを確認する
- `docker container ls`
- `docker commit kali kali`
### save
- Publicにkali-tarフォルダを作って移動する
- `docker image save -o kali.tar kali`
  - `-o`書き込むファイル名を決める
  - けっこう時間が掛かる

 ### load 
 - `docker image load -i kali.tar`
   - `-i` ファイル名を指定してロード
  
## イメージ全体を削除して掃除する
- `docker image ls -q | xargs docker image rm -f`

## dockerイメージの名前を変えるとき
- `docker tag kali2 kali`
