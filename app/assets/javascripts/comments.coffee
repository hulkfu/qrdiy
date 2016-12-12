$ ->
  $(".comments").on "mouseover mouseout", ".delete", ->
    $(this).parent().toggleClass("mover")

  .on "keydown", "[name='comment[content]']", (e) ->
    # bootstrap 默认自动提交，一下 preventDefault 的话又会不能输入
    if e.keyCode == 13
      e.preventDefault()
    # 不空时提交
    if $.trim(this.value) and e.keyCode == 13
      $(this).closest('form').submit()
      $(this).attr("disabled", "")
      # submit button
      $(this).next().find('input').attr("disabled","")

  .on "click", "[name='commit']", (e) ->
    console.log this
    if not $(this).parent().prev().val()
      e.preventDefault()
      $(this).removeAttr("disabled")
