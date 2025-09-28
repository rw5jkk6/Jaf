## コンテナのubuntuにpathを通す。下の共通のパターン
- `docker container run -it --rm ubuntu:latest`
- `apt update`
- `apt install -y vim`
- ユーザを追加する
  - `adduser ユーザ名`
- 自分のディレクトリにbinフォルダを作る
  - `mkdir -p /home/ユーザ名/bin`
- `cd /ユーザーネーム/bin`
- vimでhello.shファイルを作る
  - ```bash
    #!/bin/bash
    echo "Hello world"
    ```
- `chmod 755 hello.sh`d 
- ルートディレクトリに戻る
  - `cd /`
- ここで一回実行してみる。もちろん失敗する

## binフォルダに置くパターン
- `cp /home/ユーザーネーム/bin  /bin`
- `hello.sh`
## 環境変数にpathを通すパターン
- vimでbash.bashrcファイルの一番下に書く
  - `export PATH="$PATH:/ユーザーネーム/bin"` 
- `exec $SHELL`
- `hello.sh`
