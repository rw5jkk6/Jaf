## check
### 1
- シンボリックリンク 135
  - /bin -> /usr/bin
- 相対パス、絶対パス 133

### 2 less 138
- 表示が多い時はcatでなくlessを使う
  - `f` 一画面下にスクロールする
  - `b` 一画面上にスクロールする
  - `j` 一行進む。vimと同じ
  - `k` 一行戻る。vimと同じ
  - `/ word` wordを探索する
  - `shift プラス >` ページの一番最後にいく
  - `shift プラス <` ページの先頭にいく
  - `q` 閉じる
- lessの問題
  - `less /etc/passwd`
  - sshを検索する
  - 一番最後までいく 
- findコマンドを使って、/etcディレクトリからpasswdのファイルを探す 143

### 4 manコマンド
- ページ全体で表示する
  - `man キーワード` 
- 文字列で検索して一覧で表示する
  - `man -k キーワード` 
- 複数単語で検索する
  - `man -k キーワード | grep "キーワード"` 

### 3 グロブとは? `ls`,`ls *`の違いは? 144
- `ls *`はひとつ下の階層まで表示する
- `echo *`はlsと似てるが改行せずに表示する
- ディレクトリパーミッションは何
- shopt
  - bashの設定や表示をできるコマンド
  - `-s` on
  - `-u` off


### 5 ユーザの種類３つ 163
- idコマンド 165
- groups 166
- デフォルトのパーミッション 177
- インストール済みのパッケージを表示するコマンドは 190
- `apt list`, `apt list --installed`の違いは 193


### 6 vimとnano
- vim
- ノーマルモード(escapeを押す)
  - `dd`行を削除
  - `u`アンドゥ  
  - `j` 一行進む。vimと同じ
  - `k` 一行戻る。vimと同じ

- コピペ(範囲を指定して)
  - コピーしたい初めで`v`を押す、カーソルで範囲を指定してyを押す。貼り付けたいところでpを押す。
  - 切り取りたい時はyでなく、xを押す 
- コピペ(行)
  - コピーしたい初めで`shift+v`を押す、yを押す。貼り付けたいところでpを押す。
  - 切り取りたい時はyでなく、xを押す 
- 全範囲を指定
  - `gg`一番初めに移動
  - `v`
  - `shift + g`最後に移動 


- nano
  - 保存方法2つ
  - `ctrl + s` `ctrl + x`
  - `ctrl + x` `y`

### 7 dpkg
- `dpkg -l`と`apt list --installed`は同じ
- パッケージの削除
  - `apt remove <Package>`
- パッケージの完全削除。/etcなどの設定ファイルも削除する
  - `apt purge <Package>`


### 8 
- `ps aux`
  - `a` 自分以外のユーザ 
  - `u` ユーザ名もつける
  - `x` 端末と結びついてないのも表示
- オプションの種類
  - `-h` ショートオプション
  - `--help` ロングオプション
  - `aux` BSDオプション

- `ps -f`
- tree状にみる
```
bash
bash
ps f
```

- アプリをkillする
- killに用意されているシグナルの一覧を表示する
  - `kill -l` 
- wiresharkを立ち上げる
  - `sudo wireshark`
- wiresharkのプロセスIDを調べる
  - `ps au`または`pgrep wireshark`
- wiresharkをkillする
  - `kill 番号` 
     
### 9
- nmapはどちらのコマンドが使われるか
  - `type - nmap`
  - `echo $PATH` 
- シェル変数と環境変数の違いは


### 10
- 内部コマンド(built in)と外部コマンドの違いは
- `type echo`
- `type -a echo`
  - 両方ある場合は、内部コマンドが優先される 

- 外部コマンド
```sh
#!/bin/bash
for i in {1...10000} ;do 
    /bin/echo > /dev/null
done;
```
- 内部コマンド
```sh
#!/bin/bash
for i in {1...10000} ;do 
    echo > /dev/null
done;
```
### 番外編
- touchコマンドの本当の意味は
