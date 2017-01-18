##
# 延迟加载，为了方便 cache，即加快加载速度
$(document).on 'turbolinks:load', ->
  ##
  # authorizations，根据 current-user meta 里用户 id 和 role 来判断是否有相应的权限。
  # 有的话，则显示当前内容。
  #
  id = $("meta[name='current-user']").data("id")
  $("[data-user-id='#{id}'].auth").removeClass("hidden")
  # 根据用户的 role，需要先在 meta 里加入 role 信息
  # role = $("meta[name='current-user']").data("role")
  # $("[data-role='#{role}']").removeClass("hidden")

  ##
  # status project name
  # 比如，“在趣人网”
  #
  controller = $("meta[name='controller']").data("name")
  if controller is "projects"
    $(".status-project-name").addClass("hidden")

  # 评论的 status 不能再被评论
  $("[data-type='comment'].new-comment").addClass("hidden")
