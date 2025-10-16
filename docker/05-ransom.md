## ターゲットのシステムを勝手に暗号化する
### powerShellでアドレスを調べる
- ipconfig

### dockerのwordpress
- dockerデスクトップを起動する
- `docker composeを起動する
- コンテナに接続する
- sshdを起動する
- aptをupdateする
- rootにsecretフォルダを作って、その中にhitoshi.txtを作って、中に秘密を書いておく

### Parrot
- sshでdockerに接続する
  - `ssh -p2222 root@192.168.56.?` 
- zipコマンドをインストールする
  - `sudo apt install zip` 
- rootに移動してsecretフォルダを圧縮する
  - `zip -erm ransom.zip secret/`
  - passwordを聞かれるので適当に決める
- これで完成
- ファイルを戻す
  - `unzip ransom.zip`
  - さっき決めたパスワードを入力する 
