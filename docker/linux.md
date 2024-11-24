### networkを作成
- ネットワークを作成する
  - `docker network create --driver=bridge kali-wordpress`


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

