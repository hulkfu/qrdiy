# QRDIY.COM

转型，所有建分支保存。

怎么把qrdiy在服务器上跑起来。

# 概念

### Status
显示用户或项目的状态。

一个多态类，发布想法或follow多会出现，像豆瓣的用户流，当然还有项目的。

### Publication
可以发布的东西。比如Idea、Image、文件等。

多态类。

content_html 属性是 content 经过处理后显示在网页上的 html 代码。

## User

User 是 Devise 用来管理用户登录等的，UserProfile 是 User 的相关信息。

## 权限管理
使用 pundit，它就像 Ruby 一样，没有 DSL，只是把权限相关的分离出来，让代码更漂亮。

- authorize  验证权限，不通过会触发 Pundit::NotAuthorizedError，比如：authorize @status
- policy 验证权限，不通过返回 false，用在 view 里可以让没有权限的操作不显示，比如 if policy(@status).destroy?
- scope 处理 array 的

# Server Env
- Ruby 2.3.0
- Linux Ubuntu 16.04
- Nginx
- Passenger
- rbenv
- PostgreSQL 9.5
- imagemagick     验证码rucaptcha用，carrierwave 用MiniMagick修改图片尺寸
- ghostscript     验证码rucaptcha用
- memcached       配合dalli，缓存，验证码（如果不装，验证码会永远不通过）。

## Ubuntu Server Install

### 依赖包

```
sudo apt-get install imagemagick ghostscript memcached
```

### PostgreSQL


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

# 测试
测试就使用 Rails 自带的 Minitest 和 Fixture，简单好用。


## 数据库

连接数据库的 PostgreSQL 账号需要有 superuser 权限，在 psql 里执行：

```sql
ALTER USER myuser WITH SUPERUSER;
```

## 执行测试
默认 rake 就是测试。

```sh
# 执行测试
bin/rails test  # 或 bin/rake
# 对某个文件测试
bin/rails test -d test/models/publication_test.rb
```

# 发布

```sh
cap production install
```

# 设置

- Setting 类，配着经常变的
- security.yml，配置不经常变的，一般就存个 security_base_key
- Rails Admin，总的配置接口

## Setting

使用的 [rails-settings-cached gem](https://github.com/huacnlee/rails-settings-cached)，
config/app.yml 配合着初始化配着。

缓存流：

```
Setting.foo -> Check Cache -> Exist - Write Cache -> Return
                   |
                Check DB -> Exist -> Write Cache -> Return
                   |
               Check Default -> Exist -> Write Cache -> Return
                   |
               Return nil
```               


# Services (job queues, cache servers, search engines, etc.)

# TODO

把一般的 TODO 等标记写到代码里，用 rake notes 查看：

```sh
# 查看所有
rake notes

# 只看 TODO
rake notes:todo
```

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
