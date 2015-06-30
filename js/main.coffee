---
---
if !/eudes\.co|localhost/.test document.referrer
    $('#curtain').addClass 'start'
    $('#curtain h1#typed').typed
        strings: [$('#curtain h1').first().html()]
        typeSpeed: 100
        callback: -> $('#curtain').animate(height: '300', 1000).removeClass 'start'
$('.tooltipped').tooltip