$ ->
  updatePrintShow = ->
    $(".print-show .title").html($('[name="print[title]"]').val())
    $(".print-show .desc").html($('[name="print[description]"]').val())

  $("form.new_print").keydown ->
    window.setTimeout updatePrintShow, 100
