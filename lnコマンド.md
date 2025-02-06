## 3つの共通点
- 時間や入力など長いのを短くできる
## lnコマンド
### 説明
- 長いパスなどとにかく長いものを省略して定義できる。
- version管理などに役に立つ
- こういうのをシンボリックリンクと呼ぶ
- `ls -l`コマンドで種類が何になっているかを確認する

### Parrotでシンボリックリンクを作る
- johnでよく使うrockyou.txtはパスが深いので短くする
- `ln -s /usr/share/wordlists/rockyou.txt /shortRockyou.txt`

## aliasコマンド 
- `alias unko="sudo fping -aqg 192.168.56.0/24`
- 実はこの方法でも登録することができるが、、、

## PATH
- `echo $PATH`
- `python3 -> ../../../Library/Frameworks/Python.framework/Versions/3.11/bin/python3`
