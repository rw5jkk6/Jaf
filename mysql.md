- virtual boxのubuntuでする
## 設定
- sudo apt update
- sudo apt install mysql-server

- sudo systemctl status mysql
  - mysqlサーバが動いているのを確認する 
- sudo mysql -u root -p

## 操作
- 大文字はmysqlのコマンドで小文字は自分で作る名前
### データベースの作成
- `CREATE DATABASE myunko;`
- SHOW DATABASES;
- USE myunko;
  
- ```
  CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100));
  ```
- SHOW TABLES;
## 基礎
### データベースの挿入
- INSERT INTO users (name, email) VALUES ('hitoshi', 'hitoshi@example.com');
- INSERT INTO users (name, email) VALUES ('tinpo', 'tinpo@example.com');

### 確認、表示
- SELECT * FROM users;

### 更新
- UPDATE users  SET name = 'unko' WHERE name = 'hitoshi'

### 確認、表示
- SELECT * FROM users;

### 削除
- DROP TABLE users;
  - tableを削除
- DROP DATABASE myunko;
  - データベースを削除します   

## 標準
