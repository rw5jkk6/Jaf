- はじめにスナップショットをとる
- knockコマンドを落とす
### 論点
- 特になし

### keyword
- port knocking,brainfuck,steghide,lxd

## 攻略
- nmapをする
  - nmapは`-T 4`をつけると高速になる
  - ポートスキャンしたら22,80だが、22はfilteredになっている
  - 次のは出る時もあれば出ない時もある気がする
    - sqlinjectionができるかもと書いてある
    - /login_page, /login.php, /backup/,~などあるのがわかる

- サイトのview page sourceを見る 
  - コメントを見るとユーザ名がある
  - 画面を見ると写真しかないのに、sourceの中に他のリンクへのサイトがある。login.phpは本来見えてはいけないのだが見えている、その中に3.jpgという意味深なのがある。とりあえずアクセスしてダウンロードしておく
- gobuster
  - backup
  - imagens
  - robots.txt
  - config ->1
  - css ->2
- /backupにwordlist.txtがあるのでダウンロードする
  - `wget http://$IP/backup/wordlist.txt` 
- (他の方法で見つける)gobusterを工夫する
  - php拡張子をつける 
  - login.phpが見つかる
  - 白紙だが、マークダウンを見るとコードが書いてある
  - 3.jpgが見つかる
  - 画像をダウンロードして分析する
- 3.jpgを分析する
  - `steghide extract -sf 3.jpg` 
- ポートノッキング
- `knock -v $IP 10000 4444 65535`
  - nmapを一回づつ-pで指定する方法ではできない
  - `-r`は本来はランダム 
- ユーザ名、ssh,wordlist.txtが揃えばhydra
  - `hydra -l ~ -P ~ ssh://$IP`
  - jubiscleudo:onlymy
- jubiscleudoで3種の神器をする
  - id -> 特にない
  - SUID -> pkexecがある。/usr/bin/pkexecのバージョンを調べる。0.105OK。gccが使えるか調べるがない 
  - sudo -l -> ない
- jubiscleudoのシステム内を探索してユーザを切り替える
  - システム内探索ランキングを使う 
- hackable_3に切り替えr
- `id`コマンドでlxdであることがわかる
- lxcを使ってrootになる
- (補足)
  - pkexecもあるが、gccがないので失敗する 


## rootになってから
- port knockingのファイル見る
  - /mnt/root/etc/knockd.conf 
