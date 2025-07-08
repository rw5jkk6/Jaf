## Parrotのhydraでの攻撃をUbuntuでログをチェックする
### Ubuntu
- `tail -f /var/log/auth.log`
  - `-f`はリアルタイムで起動する 
  - これでリアルタイムでsshが接続してくるログを見ることができる

### Parrot
- sshで接続してみる
  - Ubuntuに反応があるのがわかる
- hydraの攻撃をターゲット側から見てみる  
  - `hydra -l vboxuser -P /usr/share/wordlists/rockyou.txt ssh://Ubuntuのアドレス`   
