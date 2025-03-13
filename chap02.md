## 2 仮想化
- ホストOS型
- ハイパーバイザ型


## 8 セキュリティモジュール
### SELinux
- `sudo sestatus`
  - disabled 全てが無効状態

### AppArmor
- AppArmorとは実行プログラム単位でより厳しい制限をかけられます。これを強制アクセス制御といい、パーミッションを補完する形でシステムの安全性を高めます
- 状態を確認
  - `sudo systemctl status apparmor.service` 
- AppArmorで守られているプログラムを調べる
- `sudo cat /sys/kernel/security/apparmor/profiles`
- `sudo aa-status`
  - enforceは有効
  - complainは有効だけどログが残る

## 9 ネットワークの設置
- プライベートIPアドレス
  - `10.0.0.0 ~ 10.255.255.255`
  - `172.16.0.0 ~ 172.31.255.255`
  - `192.168.0.0 ~ 192.168.255.255` 
- Global IPアドレスを調べる方法3つ
  - ネットで確認くんを使う
  - ルータに接続してアドレスを調べる
  - `curl ipecho.net/plain;echo`
- DHCPについて
- virtualBoxを起動してツールを押して、ネットワークを選択してプロパティ
- 画面下のアダプターの下にある。手動で設定をみる
  - IP4 `192.168.56.1`
  - netmask `255.255.255.0`
- DHCPのサーバを有効化
  - 192.168.56.100
  - 255.255.255.0
  - 192.168.56.101
  - 192.168.56.254   
