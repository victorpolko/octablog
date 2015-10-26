# @param [jQuery Object] target Dom element to scroll to
# @param [Integer] speed Speed (pixels per second)
$.fn.scrollWithSpeed = (target, speed = 10000, easing, complete) ->
  @stop().animate
    scrollTop: target.offset().top
    Math.abs($(window).scrollTop() - target.offset().top) / speed * 1000
    easing
    complete

# Smooth Anchors Scrolling
$('a[href*=#]:not([href=#]):not([role="tab"])').click ->
  $target = $(@hash)
  $target =
    if $target.length > 0
      $target
    else
      $("[name=#{@hash.slice(1)}]")

  $('body, html').scrollWithSpeed($target)

  false
