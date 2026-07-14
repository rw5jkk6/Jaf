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

- 53portを調べる
  - `dig @$IP greenoptic.vm axfr`
    - @$IPはドメインサーバのアドレス、ここに聞きに行く
    - greenoptic.vmは解決したいドメインネーム
    - axfrをつけることで、ドメインネームに属するサブドメイン全てを教えてくれる
  - domain nameとsub domain nameがあるので/etc/hostsに書き込む
```
greenoptic.vm
recoveryplan.greenoptic.vm
websrv01.greenoptic.vm
```

- webサイトを見る
  - どうやらサイトが攻撃を受けたよう

- gobuster
  - `account`という気になるのがある
- accountにアクセスすると怪しいURLがあるので、ディレクトリとラバーサルを試す
  - include=../../../../../../etc/passwd
  - view sourcecodeを見ると中身が見える 


- recoveryplanを見る
  - `http://recoveryplan.greenoptic.vm`を見るとBasic認証が出てくる。Basic認証は`.htpasswd`に書いてあるのでディレクトリとラバーサルで見てみる 

- ディレクトリとラバーサル
  - `include=../../../../../../var/www/.htpasswd`
  - `staff:$apr1$YQ~`
  - コピーして`staff-hash.txt`とでもしておく
- john the ripper
  - ハッシュ値からパスワードがわかる
  - staff:wheeler
- recoveryplan.greenoptic.vmにアクセスする
  - Basic認証してから、いろいろ探すと`dpi.zip`があるのでダウンロードしておく。文章を読んでいると、samに対してメールにパスワード書いておくと書いてある。
- メールを探す
  - メールはubuntuでデフォルトで/var/mail/ユーザ名にある
  - `include=../../../../../../var/mail/sam`
- dpi.zipを解凍
  - 解凍すると、pcapファイルが出てくるので、wiresharkで起動する
  - `wireshark dip.pcap`
  - 検索でftpを入力する。どこでもいいので右クリックしてtraceroute->tcp streamを選択する。ユーザ名とパスワードがわかる
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
