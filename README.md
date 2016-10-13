# QRDIY.COM

怎么把qrdiy在服务器上跑起来。

# Server Env
- Linux Ubuntu 16.04
- Nginx
- Passenger
- rbenv
- PostgreSQL 9.5

# Deploy


## 配置

shared文件夹：

- database.yml
- secret.yml

production SECRET_KEY_BASE，使用 rails secret 生成。

也可用ENV从环境读。

现在是第一次部署会提升找不到上述文件，然后在Server里目录里去创建，应该能更好的方法的，反正也只用一次。

## 发布

```sh
cap production install
```

# 问题

## 装不上nio4r

```
sudo apt-get install build-essential
```

## PG::ConnectionBad: FATAL:  Peer authentication failed for user "qrdiy"

去/etc/postgresql/9.5/main/pg_hba.conf：

```
local   all             all                                peer

# 改为

local   all             all                                md5
```

peer是用Linux的用户系统验证的，md5就是密码验证。

## 没有qrdiy_production数据库
去psql命令行里创建一个去：

```
create database qrdiy_production owner qrdiy;
```

## 部署和访问是404
主要Nginx上qrdiy的目录是current/public，因为用的capistrano部署的。

# Things you may want to cover

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
