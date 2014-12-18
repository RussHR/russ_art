(function() {
  $(document).ready(function() {
    if ($('.thumbnail').length !== 0) {
      $('.thumbnail').magnificPopup({
        type: 'image',
        closeOnContentClick: true
      });
      return {
        image: {
          titleSrc: 'data-title'
        }
      };
    }
  });

}).call(this);
