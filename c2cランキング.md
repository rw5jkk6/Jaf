## fileとコマンドの見るランキング
- コマンド、ファイルの上から順番に優先度が高い
- システムに侵入後にする順番ではない
### コマンド
- `sudo -l`
- `find / -perm -u=s -type f 2>/dev/null`
- `find / -writable -type f 2>/dev/null | grep -v /proc/ | grep -v /sys/ `
- `find / iname ? 2>/dev/null` ?はconfigとかpasswdなど
- `crontab -l`
- `getcap -r / 2>/dev/null`
  - ケーパビリティのそれ自体がrootになれるものではないが、本来はsudo権限なので大きなヒントを得られることができることがある 
- `id`自分自身が何か知る
  - sudoグループに属していれば使える
  - 自分が何かのグループに属しているかを確認する。グループは下のコマンドを使う
  - `find / -group グループ名 2>/dev/null`  
- `uname -a`
  - メモにコピーしておく 
- デーモンを調べる
  - `systemctl status NetworkManager`
  - `systemctl status apparmor`
- `netstat -antp`または`ss -lntp`動いているポートを調べられる
- `journalctl -f`
- `ps aux` or `top`
- `iptables -L`
  - sudoつける必要ある 
- `apt list --installed`

### ファイル(ディレクトリ トラバーサルでも使える)
- `/etc/passwd`どんなユーザがいるかを調べる
- `/home/ユーザ名/.ssh`上で調べたユーザ毎に調べる
- `/home/ユーザ名/.bash_history`などユーザの隠しファイル
- `/opt`
- `/var/www/html`Webサイトのディレクトリ
- `/home/`の上記以外
- `/tmp/`または`/var/tmp/`
- `/etc/サービスの設定ファイル`
- `/var/log/*`
- `/proc/self/environ`
  - ログポイズニングできるかもしれない 

### 例外(Groupから探索)
- `cat /etc/group | grep グループ名`
- `find / -group グループ名 2>/dev/null`
