## niktoとwireshark
- MrRobotでnikto使うと遅いのを解明する
- wiresharkを起動する
  - `ip a`でデバイス名を確認する。`enp0s3`というの
  - `sudo wireshark`
  -  filterに`ip.addr == Parrotのアドレス`
- 他のターミナルでniktoを起動する
- wiresharkを見ると初めは勢いよく通信するが、途中から遅くなる。これはサーバ側でスピードを調整しているためでniktoが遅いわけではない
