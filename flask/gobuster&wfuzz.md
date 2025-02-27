## 準備
- vscodeに貼り付ける
```py
from flask import Flask,request

app:Flask = Flask(__name__)

@app.route("/")
def hello():
    name = request.args.get('name', '')
    return f'<h1>Hello {name}</h1>'

@app.route("/flags")
def flags():
    return "</h1>You are otintion</h1>"

if __name__ == '__main__':
    app.run()
```


## 隠れたサイトを見つける
- serverを起動した時のターミナルのステータスコードをチェックする
- virtualboxのマネージャのツールからアクティビティを選んでCPUをチェックする
- `gobuster dir -u http://localhost:5000 -w /usr/share/wordlists/dirb/common.txt`

## 隠れたGETメソッドを見つける
- serverを起動した時のターミナルのステータスコードをチェックする
- virtualboxのマネージャのツールからアクティビティを選んでCPUをチェックする
- `wfuzz --hh 15 -w /usr/share/wordlists/wfuzz/webservices/ws-dirt.txt "http://localhost:5000?FUZZ=123456"`
 
