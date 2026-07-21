### 論点
- digコマンド(サブドメイン)
- basic認証

### keyword
- ディレクトリトラバーサル
### 論点
- ドメインネーム `apple.com`
- サブドメインネーム `mail.apple.com`

## 攻略
- nmap
  - 時間がかかるので、いつもと違うやり方をする
  - `sudo nmap -p- -vv $IP`
  - 21,22,53,80,10000
  - 53番ポートはDNSのためのポート

- webサイトを見る
  - どうやらサイトが攻撃を受けたよう

- gobuster
  - `account`という気になるのがある
- accountにアクセスすると怪しいURLがあるので、ディレクトリとラバーサルを試す
  - include=../../../../../../etc/passwd
  - view sourcecodeを見ると中身が見える 
- ここまで来て、行き詰まる。他のポートを試してみる
  - ftpはユーザ名、パスワードがわからない
  - 10000番ポートをみるとドメインネームを設定すると書いてある。ドメインネームは53番ポートのDNSが関連しているので、53を調べる 

- 53portを調べる
  - `dig @$IP greenoptic.vm axfr`
    - @$IPはドメインサーバのアドレス、ここに聞きに行く
    - greenoptic.vmは解決したいドメインネーム
    - axfrをつけることで、ドメインネームに属するサブドメイン全てを教えてくれる
  - domain nameとsub domain nameがあるので/etc/hostsに書き込む

```
192.168.56.? greenoptic.vm recoveryplan.greenoptic.vm websrv01.greenoptic.vm
```



- recoveryplanを見る
  - `http://recoveryplan.greenoptic.vm`を見るとBasic認証が出てくる。Basic認証は`.htpasswd`に書いてあるのでディレクトリとラバーサルで見てみる 

- ディレクトリとラバーサル
  - `include=../../../../../../var/www/.htpasswd`
  - `staff:$apr1$YQ~`
  - コピーして`staff-hash.txt`とでもしておく
- john the ripper
  - `sudo john --wordlist=/usr/share/wordlist/rockyou.txt staff-hash.txt`
  - ハッシュ値からパスワードがわかる
  - staff:wheeler
- recoveryplan.greenoptic.vmにアクセスする
  - Basic認証してから、いろいろ探すと`dpi.zip`があるのでダウンロードしておく。文章を読んでいると、samに対してメールにパスワード書いておくと書いてある。
- メールを探す
  - メールはubuntuでデフォルトで/var/mail/ユーザ名にある。
  - `include=../../../../../../var/mail/sam`
  - terryからsamにメールがあって、そこにパスワードが書いてある
  - (追記)昔のubuntuでは`/var/spool/mail/~`もあるが、昔の名残で今はあまり使われておらずシンボリックになっている。ちなみに、こっちでもメールは見れる
- dpi.zipを解凍
  - `unzip dpi.zip`するpasswordは`HelloSunshine123`
  - 解凍すると、pcapファイルが出てくるので、wiresharkで起動する。
  - `wireshark dip.pcap`
  - 検索でftpを入力すると、Protocolのところがftpになって、画面の真ん中の上の方で右クリックして`追跡`->`tcp stream`を選択する。ユーザ名とパスワードがわかる
  - alex:FwejAASD1というのがわかる 　 
- sshで侵入
  - `ssh alex@IP`
- id
  - wiresharkグループという気になるのがある
- `sudo -l` 使えない
- SUID
  - pkexecがある。crontabという使えそうなのがある、使ったことがないけど 
- idのwiresharkグループを使う
  - wiresharkのCUIを起動する
  - `tshark -D`
  - `tshark -i lo` または `dumpcap -i lo -w text.pcap`
  - よく見るとbase64があるのでメモっておく
- base64でするとrootAS~というのがわかる
- rootになる
  - `su root`
  - passwordはAS~   

## Question
- digコマンドは何
- 侵入後にidコマンドするのはなぜ
- wiresharkは何するもの
- TCPストリームとは、どうやってみる
- wiresharkのCUIのコマンドは
- FQDN、サブドメイン、ドメインネームとは
  - `www.yahoo.jp`
