### Windowsの事前設定
- windowsの検索でwindowsの機能と入力する
  - チェック有り
    - Linux用のwindowsサブシステム
    - virtual Machine Plattoform
  - チェック無し
    - Hyper-V    
- windowsの検索にwslと入力するとペンギンが出てくるので右クリックでピン留めする。次回以降はタスクバーにあるピンから起動する
- dockerDesktopの起動する
- `docker -v`でバージョンを確認する


### wslのターミナルにて
- docker -> wordpress でフォルダを作る。そこにcompose.yamlを作成して一番下にあるコードをコピーする
- `docker compose up -d`
- dockerでwordpressを設定のためWindowsのブラウザでアクセスする。`http://localhost:8080/wp-admin`
  - ユーザ名:hitoshi
  - パスワード:dragon
- wordpressのkindleを見ながらサイトを作ってみる

### dockerコンテナにアクセスする
- `docker container ls` コンテナ名を確認する
- `docker container exec -it コンテナ名 /bin/bash`

### compose.yaml
## 説明
- `docker compose`という技術を使えばwordpressとmariadb(mysqlみたいの)をdockerhubというサイトから同時にインストールして自動で連携して使うことができる
- mariadbやwordpressの書き方は次のサイトに書いてある。アンダーバーの次にサービスを書くのがポイント
  - `https://hub.docker.com/_/wordpress`
  - `https://hub.docker.com/_/mariadb`
- wordpress
  - environmentは環境変数でwp-config.phpに書いてたデータベースに関するもの。
  - portsは内部向けと外部向けでポートを変換するものでポートフォワーディングとも呼ぶ。8080が外部向け、80が内部で通常は80番ポートなので内部は80にしている。ブラウザからは外部の8080にアクセスする。これは他の80番ポートと被らないようにしている
  - volumesはデータを保存するところ 

```
services:
  db:
    image: mariadb:10.7
    environment:
      MARIADB_ROOT_PASSWORD: rootpass
      MARIADB_DATABASE: wordpress
      MARIADB_USER: wordpress
      MARIADB_PASSWORD: wordpress
    volumes:
      - db-data:/var/lib/mysql
  wordpress:
    image: wordpress:6.0
    depends_on:
      - db
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
    ports:
      - "8080:80"    
    volumes:
      - wordpress-data:/var/www/html
volumes:
  db-data:
  wordpress-data:
```
