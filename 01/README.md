- nmapでwarning出てるが何か
- `-sC`は何
- proftpd
- ssh-hostkey
- setcookie()
- ../../../../../etc/passwd
- /.hta,./htaccess


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

## ssh-hostkey
### 設定ファイル
- クライアント
  - id_rsa, id_rsa.pub
  - known_hosts
  - /etc/ssh_config
- サーバ  
  - authorized_files
  - /etc/sshd_config

- https://qiita.com/szly/items/54885a0594f29985d0c5

