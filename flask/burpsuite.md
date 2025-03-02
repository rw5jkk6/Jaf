- 事前に辞書を作る。hitoshisfile.txt

## Simple list
- 入力がないのにPostする
- HTMLを説明する

```py
from flask import Flask,request

app=Flask(__name__)

@app.route('/')
def index():
    return '''<!DOCKTYPE html>
    <html>
    <body>
    <form action="/api" method="POST">
    <input type="hidden" name="passcode" >
    <input type="submit" value="Get ham">
    </form>
    </body>
    </html>'''


@app.route('/api', methods=['POST'])
def api():
    if request.form['passcode']=='otintin':
            return "correct"
    else:
            return "Are you otintin?"

if __name__=="__main__":
    app.run()
```

- Burpsuiteを起動
- Proxyでいつも通りに`Get hamu`を押してRequestを取得する
- 右クリックで`send to intruder`を選ぶ
- payloadに`passcode=$unko$`と書く。$は上のAddでつける
- Payloadsに辞書を貼り付ける
- `start Attack`を押す
- 一つだけLengthが異なるのがある
- proxyに戻って入力

## BruteForce

```py
from flask import Flask,request, Response
import string, random

app=Flask(__name__)

users = [{
    'name': 'Alice',
    'password': 'z'},
    {
    'name': 'Bob',
    'password': 'd'}
]

@app.route('/')
def index():
    return '''<!DOCKTYPE html>
    <html>
    <body>
    <form action="/api" method="POST">
    Name: <input type="text" name="name" >
    Password: <input type="text" name="password" >
    <input type="submit" value="Submit" >
    
    </form>
    </body>
    </html>'''

# <input type="submit" value="Get ham">
@app.route('/api', methods=['POST'])
def api():
    name = request.form['name']
    password = request.form['password']
    
    if name not in list(map(lambda user: user['name'], users)):
        return Response(status=401, response="Incorrect")

    user_index = list(map(lambda user: user['name'], users)).index(name)
    target_user = users[user_index]

    if target_user['password'] == password:
        return Response(status=200, response=f'Logged in as {target_user["name"]}')
    else:
        return Response(status=401, response='Incorrect..')

if __name__=="__main__":
    app.run()
```
