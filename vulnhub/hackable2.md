- スナップショットをとる
### 論点
- ftpでphp-reverse-shell
### keyword
- ディレクトリ リスティング,hashes.comは使えない,crack station
## 攻略
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
- `/.runme.sh`にパスワードとユーザ名がわかる
- crack stationからonionがわかる
- SUID
  - pkexecにgccもあるのでたぶん使える
  - それ以外は使えそうにない
- `sudo -l`
- `sudo python3.5 -c 'import os; os.system("/bin/bash")'`  
