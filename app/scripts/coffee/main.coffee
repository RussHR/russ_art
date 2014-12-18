$(document).ready ->
  # initialize thumbnails
  unless $('.thumbnail').length == 0
    $('.thumbnail').magnificPopup
      type: 'image'
      closeOnContentClick: true
      titleSrc: 'data-title'
