### 次の問題をするときは今使っているコンテナを止める
- `docker cotnainer stop コンテナ名`

### ターゲットサーバの起動
- 起動スクリプトを作る
  - 第一引数はイメージ名のみを入れる (例 ham1)
  - 実行の例は ./start.sh ham1 
- `vim start.sh`
```sh
#!/bin/bash
docker container run -d --name $1 --rm -p 80:80 --net kali-wordpress rw5jkk6756/$1:1.0
docker container exec -it $1 /bin/bash service ssh start
docker container exec -it $1 bash
```
### いつでもkaliLinuxを起動できるようにスクリプトを作る
- `vim kali.sh`
```sh
#!/bin/bash
docker container run -it --name kali --privileged --rm --net kali-wordpress イメージ名
```
- `chmod +x kali.sh`
- `./kali.sh`



### 準備
- ネットワークを作成する
  - `docker network create --driver=bridge kali-wordpress`
- rockyou.txtを落とす
  - cdで/usr/shareまで行って、wordlistsをmkdirで作って移動する
  - ネットでrockyou.txtを検索してリンクをコピーする
  - で`wget ペースト`をする 

### Dockerfileでイメージを作成する
- vimでDockerfileというファイルを作って、以下をコピーする
```sh
FROM kalilinux/kali-rolling

RUN apt -y update && apt -y upgrade

RUN apt install -y kali-tools-top10

RUN apt install -y ssh vim iputils-ping net-tools

ENTRYPOINT ["/bin/bash"]
```
- buildする。15分くらいかかる。コマンドの最後にドットがあるから注意
  - `docker build -t dragon/kali:1.0 . `
- kaliLinuxを起動する
  - `docker run -it --rm  --net=kali-wordpress --name=kali dragon/kali:1.0`
- 他のターミナルを起動して
  - `docker commint kali dragon/kali:1.0`

