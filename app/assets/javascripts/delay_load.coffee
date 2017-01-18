##
# 延迟加载，为了方便 cache，即加快加载速度
$ ->
  ##
  # authorizations，根据 current-user meta 里用户 id 和 role 来判断是否有相应的权限。
  # 有的话，则显示当前内容。
  #
  id = $("meta[name='current-user']").data("id")
  $("[data-user-id='#{id}'].auth").removeClass("hidden")
  # 根据用户的 role，需要先在 meta 里加入 role 信息
  # role = $("meta[name='current-user']").data("role")
  # $("[data-role='#{role}']").removeClass("hidden")
