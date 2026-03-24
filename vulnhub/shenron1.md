### 論点
- joomlaのtemplateにreverse-shellする
- authorized_keyへの書き込み
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
- 対話型シェルをする
- ユーザが誰がいるか調べる
  - `ls -l /home` 
- joomlaの設定ファイルを見て、データベースのユーザとパスワードをコピーする
- jennyに切り替える
- SUID
  - 特になし
- `sudo -l`
  - `/usr/bin/cp`があるのがわかる
- とりあえず次はshenronユーザを目指す
- shenronユーザに公開鍵を置いて、sshをする
  - ファイル名はデフォルトでパスワードは好きなのにする
  - `ssh-keygen`
  - とりあえずjennyの隠しファイルにid_rsa.pubができたのを確認する
  - `cd /home/jenny/.ssh`
  - shenron権限でid_rsa.pubをshenronのauthorized_keysにおく。ちなみに`/authorized_keys/`とするとダメ
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
   
     
