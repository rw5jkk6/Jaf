
## Docker imageを保存する
### kaliにインストールするコマンド
- cewl,fping,gobuster,exiftool,ftp

### saveの前にインストールするコマンド
- apt install -y cewl fping gobuster exiftool ftp

### imageをcommitする
- 保存するコンテナを確認する
- `docker container ls`
- `docker commit kali kali`
### save
- Publicにkali-tarフォルダを作って移動する
- `docker image save -o kali.tar kali`
  - `-o`書き込むファイル名を決める
  - けっこう時間が掛かる

 ### load 
 - `docker image load -i kali.tar`
   - `-i` ファイル名を指定してロード
  
## イメージ全体を削除して掃除する
- `docker image ls -q | xargs docker image rm -f`

## dockerイメージの名前を変えるとき
- `docker tag kali2 kali`
