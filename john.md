## John the ripper

```sh
sudo useradd jaf
passwd 123
sudo unshadow /etc/passwd /etc/shadow > passwd_shadow.txt
cat passwd_shadow.txt | grep jaf > user_pass.txt
chmod 400 user_pass.txt
sudo john --format=crypt user_pass.txt
sudo userdel jaf
```


## 辞書
### wordistsフォルダは各ツールと同じ名前になっている
- ツールと同じファイル名
  - john,nmap,sqlmap,wfuzz,wifite
- dirb,dirbusterフォルダはサイト用
- それ以外はパスワードファイルっぽい

### `/usr/share/wordlists/dirb`と`/usr/share/wordlists/dirbuster`の違い
- `wc *`でわかるが、dirbの方が単語数が圧倒的に少ない

### 辞書の大きさ
- wordlists/rockyou.txt 14344392
- wordlists/john.lst 3559   <- john/password.lstと同じ
- wordlists/fasttrack.txt 222
