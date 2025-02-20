1. `fping -aqg 192.168.56.0/16`だと何が異なる
2. アドレスを環境変数でなく、シェル変数を使うこともできる?
5. nmapでwarning出てるが何か
6. nmapで80ポートのhttpd,2112ポートのproftpdの最後のdは何か
8. proftpdの他にftpサービスは何がある
9. ftpのコマンド一覧を見る方法は
10. ssh-hostkey
11. webのソースコードを見るコマンドは
12. /.hta,./htaccess
13. /dirb/は本来何で使われていたか
14. /dirb/にあるファイルとrockyou.txtはどう違う
15. /dirb/にある各ファイルの単語の数を降順で並べる
16. index.php.bakにある、$_POST['username']のはどこからくるか
17. Gobusterの/adminのstatusが301になっているがなぜか
18. index.php.bakにあるsetcookie()は何をしている
19. ../../../../../etc/passwdはなぜ見れるか
20. curlコマンドを使って、passwdを見る
21. passwdのユーザには7つのフィールドがあるが左から何か
22. grep -Pの-Pは何
23. BurpのRepeaterでCPUのバージョンや環境変数、ホストファイルを見る
24. Burpのリクエストに出てくるacceptの3つは何
25. /proc/は何
26. sshサーバから送られてくるfingerprintとは何か
27. **c2(c&cまたはcommand&control)とは**
28. OSのバージョンを調べる
29. ソケットの使用状況を調べる
30. passwordという単語を含んだfileを探す
31. ホームディレクトリでのls属性を左から説明する
32. ユーザのfingerprintはどこにあるか
33. ユーザのuser.txtには何が書いてある
34. ユーザのuser.txtの次に見るべき大事なファイルは
35. サーバの公開鍵はどこにある
36. /notesディレクトリのコマンドを実行してみる
37. webサイトのhtmlはどこにあるか
38. niceコマンドをマニュアルでみる
39. niceをGTFOBinsでやってみる
40. サーバの公開鍵からfingerprintはどうやって作られる?

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
