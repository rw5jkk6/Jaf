## wslのインストール
- powershell
  - `wsl --install` 
- 公式サイトからvscodeをインストールする
- vscodeを開き、拡張機能から`wsl`をインストールする
- vscodeの左下の緑色アイコンをクリックして`Connect to WSL`を選ぶ
- ubuntuの更新
```
sudo apt update
sudo apt install python3-venv python3-pip
```

## Flaskでoption
- homeにいる状態でフォルダを作る
```
mkdir option
cd option
code .
```

- 仮想環境を作る
  - `python3 -m venv option`
  - `source venv/bin/activate`
  - プロンプトに(option)とつく
- `pip install flask scipy numpy`
- `python3 app.py`
  - 127.0.0.1:5000



## 株価分析
- newのmacbook
- ターミナルでdesktopnに移動、仮想環境を作る
- `python3 -m venv jupyter`
- `cd jupyter`
- `source bin/activate`
- install
- `pip install --upgrade pip`
- `pip install jupyter`
- `pip install seaborn matplotlib pandas yfinance`
- `jupyter notebook`

