$ ->
  $(".comments").find(".delete").on "mouseover mouseout", ->
    console.log "m"
    $(this).parent().toggleClass("mover")
