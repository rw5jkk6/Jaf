## Question
- passwdのコマンドは何に使う?
- passwdはどこのフォルダにある？また　Permissionは?
- /etc/shadowは何が書いてある？また　Permissionは?

<details><summary>説明</summary>

  - passwdはパスワードを書き換えれるが、/etc/shadowはrootでしか書き換えれない。つまり一般ユーザでは書き換えれないが、なぜか書き換えることができるのはなぜか
  - これを解決するのが、SUIDファイルで実際のは一般ユーザだがコマンドはroot権限で実効できる
  - 通常はbashの起動を実ユーザ、コマンドを実行するユーザを実効ユーザと呼ぶ。通常は`実ユーザ＝実効ユーザ`になるが、suidファイルは`実ユーザ≠実効ユーザ`になる

</details>
