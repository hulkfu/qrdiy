# QRDIY.COM

转型，所有建分支保存。

怎么把qrdiy在服务器上跑起来。

# 代码简介

## 概念

### Publication
多态类，可以发布的东西。比如Idea、Image、文件等，包括：

- Idea
- ImageArray
- Attachment
- Comment 评论
- Message 私信

content_html 属性是 content 经过处理后显示在网页上的 html 代码。

Publication 的发布都会产生 status，是否显示还有别：

- Replies 类：Idea，ImageArray， Attachment 都显示。
- Comment：只在用户的页面显示。
- Message：都不显示。

### Status
一个多态类，显示用户或项目的状态。

发布想法或follow多会出现，像豆瓣的用户流，当然还有项目的。

User 的 status:

- 发布内容: Project，Idea, ImageArray, Attachment, Comment
- 赞内容： 同上
- 关注： project，其他 User


Project 的 status:

- 发布内容： Idea, ImageArray, Attachment
- 新关注的 User


### Notification
通知类。当关注的人、DIY，自己发布的内容，评论过或赞过的内容等等有更新时，发出通知。

相比 Status，它是针对用户的，只要与用户相关的东西有更新，就会给他发通知。但是更新的东西又都会有 status。一个 status 可以有多个 notification。

### Relation
多态类，表示用户于其他一切的关系，包括其他用户。

### User
User 是 Devise 用来管理用户登录等的，UserProfile 是 User 的相关信息。

### UserProfile
用户的 Profile。

## 权限管理
权限管理分为两部分，一是用 devise 的 authenticate_user! 验证的登录权限，默认不登录只能 [:index, :show]，剩下的 [:create, :update, :destroy] 等需要登录后才能操作。这是就需要验证使用权限了，这里用 Pundit 对每个 action 进行验证。

Pundit 里权限，需要使用 current_user 来判断当前用户是否具有操作的权限，所有必须先登录，否则就会报错的。可以在 Pundit 的 initialize 里验证是否登录，但是要在 except [:index, :show]，否则不登录就不能看了。

### 登录权限

### 使用权限
使用 pundit，它就像 Ruby 一样，没有 DSL，只是把权限相关的分离出来，让代码更漂亮。

- authorize  验证权限，不通过会触发 Pundit::NotAuthorizedError，比如：authorize @status
- policy 验证权限，不通过返回 false，用在 view 里可以让没有权限的操作不显示，比如 if policy(@status).destroy?
- scope 处理 array 的

# Server Env
- Ruby 2.3.0
- Linux Ubuntu 16.04
- Nginx
- Puma
- rbenv
- PostgreSQL 9.5
- imagemagick     letter_avatar 用，carrierwave 用MiniMagick修改图片尺寸
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

### rucaptcha, letter_avatar

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
使用Capistrano 3 部署，app server 用的 puma，反向代码服务器是 Nginx。

## SSL
使用 acme.sh 脚本，生成的证书在 /etc/nginx/ssl 文件夹里。

# 设置

## shared文件夹：

- config/database.yml
- config/secret.yml， 配置不经常变的，一般就存个 security_base_key, auth-key 等。它会被 push 到 git 上，里面的变量通过读取 ENV 来获得，从而保证变量的安全
- puma.rb， puma 的配置文件
- .env, 开发测试的环境变量，使用 [dotenv-rails](https://github.com/bkeepers/dotenv)

production SECRET_KEY_BASE，使用 rails secret 生成。

变量从ENV读，使用跟目录里的 .env 文件来配着。

现在是第一次部署会提升找不到上述文件，然后在Server里目录里去创建，应该能更好的方法的，反正也只用一次。

## Setting

Setting 类，配置经常变的，可以公开的，可以传到 github 上同步的

使用的 [rails-settings-cached gem](https://github.com/huacnlee/rails-settings-cached)， config/app.yml 配合着初始化配着。

因为加了 cached，所有使用的时候需要注意打开 config.cache_store.

```ruby
# Enable/disable caching. By default caching is disabled.
if Rails.root.join('tmp/caching-dev.txt').exist?
  config.action_controller.perform_caching = true

  config.cache_store = :dalli_store
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=172800'
  }
else
  config.action_controller.perform_caching = false

  config.cache_store = :null_store
end
```

我可以在源码它的源码里加个 can_cache? 方法来判断。

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

# 监控

# 管理
Rails Admin。


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

## 前端测试
这里用的是 [Jesmine](https://jasmine.github.io)。

已经封装好了脚本：

```bash
./test.sh js
```


# 发布

```sh
cap production install
```

# 备份
使用 [backup gem](https://github.com/backup/backup).

# Services (job queues, cache servers, search engines, etc.)

# TODO

- exception_notification gem

## 代码中的
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

## 安装不上 pg gem

```bash
sudo apt install libpq-dev
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

## native build 不过 nokogiri

```rb
xcode-select --install
gem install nokogiri
```

## pghero enable query stats
参考 https://github.com/ankane/pghero/blob/master/guides/Query-Stats.md

需要赋予 Superuser 权限：

```bash
ALTER ROLE user WITH Superuser;
```

## extension/pg_stat_statements.control": No such file or directory

首次部署时，执行 "rake db:setup" 报错。

需要安装：

```bash
 sudo apt install postgresql-contrib-9.x

 sudo su postgres
 psql

 =# alert user name superuser;
```

## CROS 问题
assets 的话需要修改 nginx 配置，参考[这里](https://enable-cors.org/server_nginx.html)。

服务的话使用 [rack-cors](https://github.com/cyu/rack-cors) 配置。
