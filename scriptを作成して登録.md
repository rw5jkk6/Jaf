## 自分で作ったシェルスクリプトを、どこからでも使えるようにする

- まずスクリプトを作る。ファイル名`cheer.sh`
  - ここでは、スクリプトを実行したら`hitoshiは？人の女を抱いた`と表示させる。？人のところは第一引数で決めることができるとする。
- homeの下に`bin`フォルダを作る
- 作ったスクリプトをbinフォルダに移動させる
- ファイルを再読み込みする
  - `source ~/.profile` 
- スクリプトを実行する

   参考
- ~/.profile
```sh
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
```

### エイリアスの利用 
- `alias unko="sudo fping -aqg 192.168.56.0/24`
- 実はこの方法でも登録することができるが、、、

### プロンプトの書き換え(bash)
- プロンプトが長すぎるので短くする
- `echo $PS1`
  - これが 
- `vim .bash_profile`
- 一番下の行に書く
  - `export PS1="\h:\W \$"`

### プロンプトの書き換え(zsh)
- `echo $PS1`で確認する
- `sudo vim /etc/zshrc`
- 下の行の方に #Default promptがあるので書き換える
  - `PS1="%n %1~ %" `
- vimを終了
  - `:wq!`
- ターミナル再起動したら変わっているはず

### ポートスキャンを作る
- ネットスキャンでアドレスを確認する
- `vim portscan`
  - $1はスクリプトの引数に当たる 
```sh
#!/bin/bash

sudo nmap -A 192.168.56.$1
```
- `portscan ポート番号`
