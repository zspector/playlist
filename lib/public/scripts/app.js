$(document).ready(function() {
  $('.item-hover').hover(function(){
    $(this).addClass('hover');
  }, function(){
    $(this).removeClass('hover');
  });
})
