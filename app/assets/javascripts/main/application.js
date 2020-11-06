// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


$(function(){
  $("#user_image").on("change", function(e){
    var reader = new FileReader();
    reader.onload = function(e){
      $(".image").attr("src", e.target.result);
    }
    reader.readAsDataURL(e.target.files[0]);
  });
  $("#word_image").on("change", function(e){
    var reader = new FileReader();
    reader.onload = function(e){
      $(".image").attr("src", e.target.result);
    }
    reader.readAsDataURL(e.target.files[0]);
  });
  
  $("#theTarget").skippr({
  transition: "fade",
  speed: 1000,
  easing: "easeOutQuart",
  navType: "block",
  childrenElementType: "div",
  arrows: true,
  autoPlay: true,
  autoPlayDuration: 5000,
  keyboardOnAlways: true,
  hidePrevious: false
})

});
