# WHOOSH
# Super-easy and super-fast slide-in animations on scroll.
# Built by Clive Chan for SkillFlow, 2016

# Simply add attributes 
#   data-whoosh="top"  # direction it's whooshing from
#   data-delay="500"   # optional

# Issues
#   works for only for normally positioned elements.

$ ->
  offset = '-2em'

  whoosh = [];
  throttle = new Date().getTime()
  msDelay = 200

  $(window).on 'scroll.whoosh', ->
    if whoosh.length == 0
      $(window).off('.whoosh')
      return
    if new Date().getTime() - throttle < msDelay
      return
    throttle = new Date().getTime()
    curr = $(window).scrollTop()
    while whoosh.length > 0 && curr >= whoosh[0].scrollTarget
      whoosh.shift().callback()

  $('*[data-whoosh], *[data-whoosh-from]').each ->
    $this = $ this
    dir = $this.data('whoosh') || $this.data('whoosh-from')
    $this.css
      position: 'relative'
      opacity: 0
      top: if dir == 'top' then offset else 0
      right: if dir == 'right' then offset else 0
      bottom: if dir == 'bottom' then offset else 0
      left: if dir == 'left' then offset else 0
    setTimeout ->
      $this.css
        transition: 'all 0.5s'
      $(window).trigger 'scroll.whoosh'
    , 500
    reset = ->
      $this.css
        opacity: 1
        top: 0
        right: 0
        bottom: 0
        left: 0
    whoosh.push
      # Get the current middle of the element, minus the window height.
      #   Once we match up, then the bottom of the window is matching with the middle of the element.
      scrollTarget: $this.offset().top + $this.height() / 2 - $(window).height()
      callback: ->
        if $this.data('delay')
          setTimeout reset, parseInt $this.data('delay')
        else
          reset()

  whoosh.sort (a,b)->a.scrollTarget-b.scrollTarget
