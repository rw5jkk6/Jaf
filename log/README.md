### 問題(access1000.log)
1. logの数は
2. ログはいつから始まって、いつで終わっている
3. user-agentごとのアクセス回数
4. 送信元の一番多いIPアドレス
5. 怪しいuser-agentのIPアドレスは？いつから、いつまで？
6. どこへのアクセスが多かったか
7. どのタイミングで侵入に成功したか？詳細の内容は？
8. サイト内で何か行なったか？
9. cmdでosコマンドインジェクションしてる？cmdで探す


### 解答(access1000.log)
- 答えと解法がバラバラなので注意
1. 1000
2. 7/20-19:22:53 ~ 9/1-02:19:23
3. `awk '{print $NF}' access1000.log | sort | uniq -c | sort -nr`
4. `awk '{print $1}' access1000.log | sort | uniq -c | sort -nr`
5. `grep -an "gobuster/3.6" access1000.log
6. `awk -F '"' '{print $2}' access1000.log | sort | uniq -c | sort`
7. `grep -a -E 'wp-login.php|wp-admin' access1000.log | grep '200'`
8. `grep -a -E -v 'wp-login.php|wp-admin|gobuster' access1000.log `
9. `grep -a -E -v 'wp-login.php|wp-admin|gobuster' access1000.log | grep -a 'cmd'`
