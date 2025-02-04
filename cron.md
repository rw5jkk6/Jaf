## 定期的に自動でコマンドを実行する
### ここでは1分ごとにtest.txtにHelloと入力する
- apt install -y cron
- Homeにtest.txtファイルを作る
- crontab -e
  - `*/1 * * * * echo "Hello" >> ~/test.txt`
  - `*`はスペースで空ける
- 書いてあるかを確認
  - crontab -l
- service cron start
- service cron status
- 数分経ったらファイルに記入されているのを確認する 
