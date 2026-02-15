- はじめにスナップショットをとる
- knockコマンドを落とす
### 論点
- 特になし

### keyword
- port knocking,brainfuck,steghide,lxd

## 攻略
- nmapをする
  - nmapは`-T 4`をつけると高速になる。試すとわかるが、全portスキャンならだいたい7秒ぐらい早い
  - ポートスキャンしたら22,80だが、22はfilteredになっている
  - 次のは出る時もあれば出ない時もある気がする
    - sqlinjectionができるかもと書いてある
    - /backup/,~などあるのがわかる。/login_page, /login.php, この2つはnmapでしか出てこないので覚えておく

- サイトをチェックする
  - view page sourceを見る 
  - コメントを見るとユーザ名がある
  - 画面を見ると写真しかないのに、sourceの中に他のリンクへのサイトがある。login.phpは本来見えてはいけないのだが見えている、その中に3.jpgという意味深なのがある。とりあえずアクセスしてダウンロードしておく
- `gobuster -u $IP -w $dirsmall -x php,txt`
  - デフォルトで-xはつける。サイトを順に見ていく
  - login.phpのマークダウンには3.jpgがあるのでダウンロードしておく
  - backupからはwordlist.txtをダウンロードしておく　`wget http://$IP/backup/wordlist.txt`
  - imagens
  - robots.txtには/configと記載がある
  - configには1.txtがある。これはbase64
  - cssには2.txtがある。これはbrainfuck 
- 3.jpgを分析する
  - `steghide extract -sf 3.jpg` 
- ポートノッキング
- `knock -v $IP 10000 4444 65535`
  - nmapを一回づつ-pで指定する方法ではできない
   
- ユーザ名、ssh,wordlist.txtが揃えばhydra
  - `hydra -l ~ -P ~ ssh://$IP`
  - jubiscleudo:onlymy
- jubiscleudoでシステム内探索ランキングを使う
  - id -> 特にない
  - SUID -> pkexecがある。/usr/bin/pkexecのバージョンを調べる。0.105OK。gccが使えるか調べるがない
    - PwnKitは使えるのでrootになれる 
  - `sudo -l` -> ない
  - `getcap -r / 2>/dev/null`
  - `ps aux | grep root`
  - `ss -lntp`
  - `find / -type f -user jubiscleudo 2>/dev/null`
    - ユーザの所有者を探す
  - `find / -iname "*backup*" -type f 2>/dev/null`  
- jubiscleudoのシステム内を探索してユーザを切り替える 
- hackable_3に切り替える
- `id`コマンドでlxdであることがわかる
- lxcを使ってrootになる

```
git clone  https://github.com/saghul/lxd-alpine-builder.git
cd lxd-alpine-builder
./build-alpine
```
- (補足)
  - pkexecもあるが、gccがないので失敗する 


## rootになってから
- port knockingのファイル見る
  - /mnt/root/etc/knockd.conf 
