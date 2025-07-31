### icmpを全部遮断
- `sudo iptables -L`
  - テーブルの確認 
- `sudo iptables --append INPUT --protocol icmp --jump DROP`
  - または`sudo iptables -A INPUT -p icmp -j DROP` 
- `sudo iptables -L`
- `sudo iptables -F`
  - 削除 

### icmpを特定(ネットワーク)の遮断
- `sudo iptables -A INPUT -s 192.168.56.104 -j DROP`
  - `-s 192.168.56.0/24` 
