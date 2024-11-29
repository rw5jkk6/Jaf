### 全部削除する
- コンテナ
  - `docker container ls -aq | xargs docker container rm -f`
- イメージ
  - `docker container ls -q  | xargs docker image rm -f`



### Dockerfileでイメージを作成する
- vimでDockerfileというファイルを作って、以下をコピーする
```sh
FROM kalilinux/kali-rolling

RUN apt -y update && apt -y upgrade

RUN apt install -y kali-tools-top10

RUN apt install -y ssh vim iputils-ping net-tools gobuster wpscan fping
```
- buildする。15分くらいかかる。コマンドの最後にドットがあるから注意
  - `docker build -t kali . `
- docker desktopにkaliイメージがあるのを確認する

### いつでもkaliLinuxを起動できるようにスクリプトを作る
- `vim kali.sh`
```sh
#!/bin/bash
docker container run -it --name kali --privileged --rm --net kali-wordpress kali
```
- `chmod +x kali.sh`
- `./kali.sh`

### 準備
- rockyou.txtを落とす
  - cdで/usr/shareまで行って、wordlistsをmkdirで作って移動する
  - ネットでrockyou.txtを検索してリンクをコピーする
  - で`wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt`をする 
