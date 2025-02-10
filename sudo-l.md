## sudo -lの設定の仕方
- ParrotOSでする
### 説明
- unko.shのスクリプトを作るが、これはroot権限でしかできないが、一般のユーザであるunkoにroot権限でunko.shだけを実行できるように設定する
### unkoユーザの追加とunko.shの設定
- rootになる
- `useradd -m unko`
- unkoにパスワードを設定する。
  - `passwd unko`
  - パスワードはunkoにでもしておく
- ルートにnotesフォルダを作って、hello unkoと表示するシェルスクリプト,unko.shを作る
- Permmisionは`chmod 700 unko.sh`

### unkoはunko.shを実行できない
- unkoユーザになる
- `/bin/nice /notes/unko.sh`を実行する
- 当然実行できない

### sudo -lの設定をする
- rootに戻る。
  - `su unko`でもできるはずだが、ダメなら,`ctrl + d`で戻る
- `sudo visudo -s`を開けて下のを書く。
  - これはsudoを管理するファイル専用のvimみたいなもので、vimと異なり保存の際に正確に書いてあるかテストしてくれる。`-s`はstrict(厳格)の意味で、よりテストしてくれる。vimでも開くことができるが、readonlyなので強制的に保存する必要がある
  - `%sudo ALL=(ALL:ALL) ALL`
  - %があるのはグループのこと、つまりsudoはグループのこと
- `unko  ALL=(ALL:ALL) /bin/nice /notes/*`
- 指示に従って閉じる

### unkoでunko.shを実行する
- unkoになる
- `sudo /bin/nice /notes/unko.sh`を実行する

### rootになる
- `sudo /bin/nice /notes/../bin/bash`を実行する

## unkoをsudoグループに追加する
- sudoはグループなので、`/etc/group`にuserが追加されているわかる。当然、unkoもsudoグループに追加すればsudoが使えるようになる
- unkoをsudoグループに追加する。まずsudoが使えるかチェックするためにパスワードファイルを見る
- `sudo /etc/shadow`
  - システムのパスワードはrootでしか見れないがsudoなら見れるはずだが、当然見れない
- rootに戻る
- `usermod -aG sudo unko`
- /etc/groupを確認する
- `sudo cat /etc/shadow`が見れる


## Deleteで元に戻す
- /noteの削除
- `userdel unko`
- `rm -rf /home/unko`
- /etc/sudoersから消す

## 補足

- ALLが４つあるが、左からホスト、ユーザ、グループ、コマンドでここでは一番右のsudoグループは全てのコマンドが使えると覚えておいたらいい
- `unko  ALL=(ALL:ALL) /bin/nice /notes/*`
- 上のはこうも書ける、ちなみにコマンドはフルパスで書く必要がある
- `unko  ALL=(ALL) NOPASSWD: /bin/nice /notes/*`
