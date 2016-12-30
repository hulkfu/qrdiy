$ ->
  $(".publications-actions a").click ->
    $(".publications-actions a").removeClass("active")
    $(this).addClass("active")
