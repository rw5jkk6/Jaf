### zipコマンドを使う前に
- コマンドの使い方は
- 暗号化のオプションは

### zipコマンドで暗号付きの圧縮する
- unko.txtとtinko.txtを作る
- zipコマンドで圧縮する
  - `zip -e test.zip unko.txt tinko.txt`
  - passwordを入力する、ここではmonkeyとしておく
- 解凍してみる
  - `unzip test.zip`
  - passwordの入力
 
### zipファイルの暗号を解読する
- `fcrackzip -D -p /usr/share/wordlists/rockyou.txt -u test.zip`
