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
- 
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
