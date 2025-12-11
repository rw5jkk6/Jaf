### 論点
- 特になし

### keyword
- port knocking,brainfuck,steghide,lxd

### 攻略
- ポートスキャンしたら22,80だが、22はfilteredになっている
- コメントを見る
  - ユーザ名がある 
- gobuster
  - robots.txt
  - config ->1
  - css ->2
- /backupにwordlist.txtがあるのでダウンロードする
  - `wget http://$IP/backup/wordlist.txt` 
- gobusterを工夫する
  - php拡張子をつける 
  - login.phpが見つかる
  - 白紙だが、マークダウンを見るとコードが書いてある
- 3.jpgが見つかる
  - 画像をダウンロードして分析する
  - `steghide extract -sf 3.jpg` 
- ポートノッキング
- `knock -v $IP 10000 4444 65535`
  - nmapを一回づつ-pで指定する方法ではできない
  - `-r`は本来はランダム 
- ユーザ名、ssh,wordlist.txtが揃えばhydra
  - `hydra -l ~ -P ~ ssh:$IP`
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
