$ ->
  # which $('[name="print[title]"]') or $('[name="print[description]"]')
  updatePrintShow = (which) ->
    name = which.attr('name')
    name = name.slice(6, -1)

    window.setTimeout ->
      $(".print-show .#{name}").html(which.val())
    , 100

  $("form.new_print").on 'keydown', 'input,textarea', ->
    updatePrintShow($(this))
