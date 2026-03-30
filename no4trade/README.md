## wslのインストール
- powershell
  - `wsl --install` 
- 公式サイトからvscodeをインストールする
- vscodeを開き、拡張機能から`wsl`をインストールする
- vscodeの左下の緑色アイコンをクリックして`Connect to WSL`を選ぶ
  - 左下に`WSL:Ubuntu`と出たら成功 
- ubuntuの更新
  -  vscodeの上のバーから表示を選んで、ターミナルを選ぶ
```
sudo apt update
sudo apt install python3-venv python3-pip
```
- 過去のを全部削除して綺麗にする
```
cd
rm -rf .
``` 

## Flaskでoption
- home/ユーザ名/にいる状態でフォルダを作る
```
mkdir option
cd option
code .
```
- 新しいvscodeが立ち上がる。さっきと同じようにターミナルを開いて仮想環境を作る
  - `python3 -m venv option`
  - `source venv/bin/activate`
  - プロンプトに(option)とつく
- `pip install flask scipy numpy`



## 株価分析　<- これは関係ない
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

