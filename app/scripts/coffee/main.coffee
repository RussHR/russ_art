$(document).ready ->
  # initialize thumbnails
  unless $('.thumbnail').length == 0
    $('.thumbnail').magnificPopup
      type: 'image'
      closeOnContentClick: true
    image:
      titleSrc: 'data-title'