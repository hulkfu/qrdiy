##
# 因为使用了 Turbolink，需要在 Turbolink load 时执行，而不是 page ready 时
#
$(document).on 'turbolinks:load', ->
  $(".comments").on "mouseover mouseout", ".delete", ->
    $(this).parent().toggleClass("mover")

  .on "keydown", "[name='publishable[content]']", (e) ->
    $submit = $(this).next().find('input')
    # bootstrap 默认自动提交，一下 preventDefault 的话又会不能输入
    if e.keyCode == 13
      e.preventDefault()

    # 判断输入是否为空
    setTimeout =>
      if $.trim(this.value)
        $submit.removeAttr("disabled")
      else
        $submit.attr("disabled","")
    , 100

    # 不空时提交
    if $.trim(this.value) and e.keyCode == 13
      $(this).closest('form').submit()
      # 可以保证不被多次提交
      # $(this).attr("disabled", "")
      # submit button
      $submit.attr("disabled","")

  .on "click", "[name='commit']", (e) ->
    if not $(this).parent().prev().val()
      e.preventDefault()
      $(this).removeAttr("disabled")
