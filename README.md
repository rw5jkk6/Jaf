## する順番
### 8月
- 1 -> 5 -> 8 -> 2 -> 3 -> 7 -> 10 -> 11 -> 12(テスト)

## Parrotのアップグレード
- `sudo apt parrot-upgrade`

## 事前にインストールしておく
### vulnhubのフォルダに入れておく
- php-reverse-shell.php
  - `https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php`
  - ここからコピーして、php-reverse-shell.phpファイルにペーストしてvulnhubフォルダに入れておく

- exploitsearch
  - exploitを探して、そのまま実行できる
  - `sudo apt update`
  - `sudo apt -y install exploitdb` 
- CewL cf471
  - `/vulnhub/` 　フォルダに移動する
  - `git clone https://github.com/digininjya/CeWL`
  - `cd CeWL`
  - `sudo gem install bundler`
  - `bundle install`
  - `chmod u+x ./cewl.rb`
  
- droopscan cf417
  - インターネットに繋げて
  - `pip install --break-system-packages --user droopescan`
  - pip listにはあるが、パスが通っていないので実行できない問題が起こる
  - `sudo find / -name droopescan`で調べて絶対パスで実行する
- Linepease 671
  - `wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -p ~/`
  - linpeas.shのフォルダまでいく
  - `cp linpeas.sh ~/vulnhub/` 
- wig 468
  - wordPressを調べる
  - sudo apt install wig 
- wpscan 691
  - wordPressを調べる
  - `sudo gem install wpscan` 
- SecList
  - パスワードの辞書
  - `cd ~/vulnhub`
  - `wget https://github.com/danielmiessler/SecLists/archive/refs/heads/master.zip`
  - `unzip master.zip`

## IPアドレスの紹介
### IPアドレスの紹介
- `192.168.56.1` hostであるWindowsのこと
- `192.168.56.100` DHCP

### IPアドレスの固定
- ParrotOSのアドレスを`192.168.56.10`にする
- System -> Preferences -> Internet and Network -> Advanced Network Configuration
- Wired connection1 -> IPv4 Settings
- Method Manual
```
Addresss 192.168.56.10
Network 24
Gateway 192.168.56.14
```
- save
## ターゲットOSをインポートする
- ターゲットOSをサイトからダウンロードする
  - (例) `https://www.vulnhub.com/entry/potato-1,529/`のDownload(Mirror)からダウンロード
- ダウンロードしたファイルをダブルクリックする
- ~virtualboxでParrotOSでやった時のようにダウンロードした`potato.ova`ファイルをインポートする~
- 全部デフォルトでOK
- 表示の下の方に、[無効な設定が見つかりました]と出ると設定が変えれないので設定を変更する
- **設定のネットワークはParrotOSと同じホストオンリーアダプターにする**
- 起動できるか確認する


## VirtualBoxとParrotOSのインストール
- WindowsにVirtualBoxをダウンロードする
- ParrotOSをダウンロードする ParrotOSを検索してParrotSecurity
  - Virtual -> Security -> AMD64 -> DownLoad
- 設定はデフォルトのままでいい

## VirtualBoxとParrotOSの設定
- VirtualBoxのExtensionPackのインストール
  - `https://www.virtualbox.org/wiki/Downloads`
  - ​All supported platformsからダウンロードする
- マネージャーの左から`ParrotOSSeccurityEdition`を選んで`設定`を押す
  - ネットワークのアダプター1から割り当てにホストオンリーアダプターを選ぶ
  - 仮想マシンを起動して右下のアイコン(パソコンが前後に2台に並んでるやつ)をクリックするとIPアドレスが割り当てられてるのを確認する  

## 拡張子がvmdkをインストールする
- vmdkファイルをダウンロードしたら、わかりやすいようにデスクトップにコピーする
- VirtualBoxを起動する
- 新規 -> 名前を入力する -> ハードウェアを選択する -> すでにある仮想ハードディスクファイルを使用する -> さっきのデスクトップにコピーしたファイルを選択 -> 完了
- いつものように起動する
