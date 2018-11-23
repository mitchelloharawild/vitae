 $(document).ready(function(){
  slideshow.on('beforeShowSlide', function (slide) {
    $("video").each(function() {
      $(this).get(0).currentTime = 0;
      $(this).get(0).play();
    });
  });
 });