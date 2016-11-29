# QRDIY.COM

转型，所有建分支保存。

怎么把qrdiy在服务器上跑起来。

# Server Env
- Ruby 2.3.0
- Linux Ubuntu 16.04
- Nginx
- Passenger
- rbenv
- PostgreSQL 9.5
- imagemagick     验证码rucaptcha用，carrierwave 修改图片尺寸
- ghostscript     验证码rucaptcha用
- memcached       配合dalli，缓存，验证码（如果不装，验证码会永远不通过）。

## Ubuntu Server Install

```
sudo apt-get install imagemagick ghostscript memcached
```

# Mac Development Env

## Ubuntu
同Server。

## Mac

### PostgreSQL
直接下载[Postgres.app](http://postgresapp.com/)，拉到应用目录里就可以使用。

然后在.bash_profile里配置PATH:

```
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
```

默认是trust认证，所以只需要有用户名和host就可以连接。

把config/database.example.yml 复制到config/database.yml就可使用。

### rucaptcha

```
brew install imagemagick ghostscript
```

还需要下面的memcached支持。

### memcached

```
brew install memcached --with-sasl
# 用brew安装之后下面会提示怎么启动
```

# Deploy
使用Capistrano 3 部署，并用了相关gem：

```rb
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
```

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

# 跑测试

# Services (job queues, cache servers, search engines, etc.)


# 遇到的问题

## Shared文件没有
手动到Server去创建。

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
