## cewlの使い方
- `vim /var/www/html/index.html`を開く、保存して閉じる
```
<html><body>
<p>hitoshi ha delica de hajimaru</p>
<p>hamuwotumu hamuwotumu hitoshi ha keitora de hasiru</p>
<p>korega enen to tuduku</p>
</body></html>
```
- `sudo systemctl start apache2`
- ブラウザでページを確認する
- `./cewl.rb localhost -w hitoshi.txt`
- hitoshi.txtの中身を見る

## vimの設定
### 行番号を表示
- `:set number`
  - `:set nonumber`
### 制御文字を表示
- `:set list`
  - `:set nolist`  
### `:shell`
- vimを一時的に中断して、新しいシェルを起動する

## rootへの昇格で他のGTFOBinsで昇格する
- 全部で５通りある

## root取得後にmysqlのデータベースでrootのパスワードを解読する
- /var/www/wp-config.php
- ユーザ名とパスワードをチェックする
- mysql -u ~ -p
- show databases;
- use ~;
- show tables;
- select * from ~\G
- rootのパスワードをコピーする
- john the ripperで解読する

## ApacheのVirtualHost
- Apacheのvirtualhostでブラウザからのリクエストをもとにコンテンツを変えることができる

- ブラウザを起動させる。inspect,network,reload,Getをクリック、右下にHostが出てくる
- Hostフィールドは、WebサーバーがどのWebサイトに対するリクエストなのかを識別するために非常に重要です。1つのIPアドレスで複数のWebサイト（バーチャルホスト）を運用している場合、サーバーはこのHostフィールドの値を見て、適切なWebサイトのコンテンツを返送します。
- /etc/hostsを書き換える。
  - `192.168.56.104 dc-2` 
- hostsを書き換えても換えなくてもRequestHeaderは変わらない
  - Host:dc-2
- 
