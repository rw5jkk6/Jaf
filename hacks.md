- homeにbinフォルダを作る
- `mkdir bin`
- `vim hacks.sh`

```sh
#!/bin/bash

sudo fping -aqg 192.168.56.0/24 | tee fping.log
# 104はParrotのアドレスの一番最後の数字
t=$(grep -v 100 fping.log | grep -v 104)
echo '-----------'
echo 'target IP Adress'
echo '$t'
echo '-----------'
sudo nmap -sS -p- -T4 --system-dns $t | tee nmap1.log
```

- PATHを通す。homeに戻る
- `vim .bashrc`
- 一番下に書く
- `PATH=$PATH:~/bin`
- targetのサーバのディレクトリを作って、新しいターミナルを開けてコマンドを打つ
- `hacks.sh`
