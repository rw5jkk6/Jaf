- nmapでwarning出てるが何か
- `-sC`は何
- proftpd
- ssh-hostkey
- setcookie()
- 


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

