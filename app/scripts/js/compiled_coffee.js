(function() {
  $(document).ready(function() {
    if ($('.thumbnail').length !== 0) {
      return $('.thumbnail').magnificPopup({
        type: 'image'
      });
    }
  });

}).call(this);
