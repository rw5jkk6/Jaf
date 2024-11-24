## ubuntuを起動する
`docker container run -it --name コンテナ名 --privileged --rm --net kali-network ubuntu`
## sshをhydraで突破する
- userを作る
```
useradd -m steven
passwd steven
```
- passwordは`dragon`にする
- sshを使えるようにする。途中で時間の地域を聞いてくるのでasia,tokyoを選ぶ
```sh
apt update && apt -y upgrade
apt install -y unminimize
apt install -y ssh
apt install -y ufw
ufw status
ufw enable
ufw allow 22
ufw status
```
- vimでsshd_configを書き直す
```
apt install -y vim
vim /etc/ssh/ssh_config
```
- port 22のコメントを消す
- `service ssh start`
  - 再起動するたびにsshはcloseになるので、このコマンドは打つ 

## kali側からsshで接続する
`ssh steven@172.19.0.4`
