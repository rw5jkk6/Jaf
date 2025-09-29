## wordpressとmariadbのコンテナは別物なのでOSを調べる
- ターミナルを2こ開ける。次からのを別々にする
- コンテナの名前を調べる
  - `docker container ls`
- コンテナに接続してバージョンを調べる
  - `docker container exec -it コンテナ名 /bin/bash`
- コンテナ内に接続後、バージョンを調べる
  - `cat /etc/*release`
