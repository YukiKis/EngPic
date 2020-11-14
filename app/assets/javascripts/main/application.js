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
  });
  
  // $(".card").on("mouseover", function(){
  //   $(this).animate({ boxShadow: "5px 5px 5px #ccc"}, 0.3);
  // }).on("mouseout", function(){
  //   $(this).animate({ boxShadow: "2px 2px #ccc"}, 0.3);
  // });
  
  $(".answer-card").on("mouseover", function(){
    $(this).find(".answer-form").stop(true).animate({ opacity: 1 }, 300);
  }).on("mouseout", function(){
    $(this).find(".answer-form").stop(true).animate({ opacity: 0.5 }, 300);
  });
  
  // when type the wrong form in email-form, change color  
  $("#user_email").on("change", function(){
    var pattern =  /.+@.+/i
    var value = $(this).val();
    if( !value.match(pattern) ){
      $(this).addClass("invalid");
      // $(this).parent().append(`<span class="wrong">WRONG</span>`);
    }else{
      $(this).removeClass("invalid");
    };
  });
  
  // when name is too short / long, change color
  $("#user_name").on("change", function(){
    var value = $(this).val()
    if(value.length < 2){
      $(this).addClass("invalid");
    }else if(value.length > 20){
      $(this).addClass("invalid");
    }
    else{
      $(this).removeClass("invalid");
    }
  })
  
  // when password is too short, change color
  $("#user_password").on("change", function(){
    var value = $(this).val();
    if(value.length < 6){
      $(this).addClass("invalid");
    }
    else{
      $(this).removeClass("invalid");
    }
  })
  
  // when password_confirmation is wrong, change color
  $("#user_password_confirmation").on("change", function(){
    var value = $(this).val();
    if(value.length >= 6 && value !== $("#user_password").val()){
      $(this).addClass("invalid");
    }else{
      $(this).removeClass("invalid");
    }
  })
  
  $("#word_name, #word_meaning").on("change", function(){
    if($(this).val() === ""){
      $(this).addClass("invalid");
    }else{
      $(this).removeClass("invalid");
    }
  })
});
