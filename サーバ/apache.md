## siteの作り方
- siteの保存場所 `/var/www/html/index.html`
  - 元にあるindex.htmlをコピーしておく
  - index.htmlを全部削除してから何か書く 
- `systemctl start apache2`で起動させる
- ブラウザでアクセスする

## 隠しファイル
- `.htaccess`fileがどこにあるかわからない

## Log
- apacheのアクセスログは`/var/log/apache2/access.log`
