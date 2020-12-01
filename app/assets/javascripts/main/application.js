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


$(document).on("turbolinks:load", function(){
  $(window).on("resize", function(){
    $(".container").outerHeight($(window).height());
  })

  $(window).trigger("resize");
  
  $("#user_image").on("change", function(e){
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
  
  $("#word_image").on("change", function(e){
    var reader = new FileReader();
    reader.onload = function(e){
      $(".image").attr("src", e.target.result);  }
    reader.readAsDataURL(e.target.files[0]);
    $("#word_tag_list").val("");
    $("#word_is_auto").prop("disabled", false);
    $(".is-auto-label").text("自動でタグを追加する(3個)")
  });
  
  $("#word_tag_list").on("change", function(){
    var tag_list = $("#word_tag_list").val().split(",")
    if(tag_list.length >= 4){
      $(".is-auto-label").text("タグ数が多すぎます");
      $("#word_is_auto").prop("disabled", true);
    }
  })
  
  $(".answer-card").on("mouseover", function(){
    $(this).find(".answer-form").stop(true).animate({ opacity: 1 }, 300);
  }).on("mouseout", function(){
    $(this).find(".answer-form").stop(true).animate({ opacity: 0.5 }, 300);
  });
  
  // when type the wrong form in email-form, change color  
  $("#user_email").on("change", function(){
    var pattern =  /^[^@\s]+@[^@\s]+$/
    var value = $(this).val();
    if(value == ""){
      $(this).addClass("invalid").attr("title", "メールアドレスは必須項目です。") 
    }else if( !value.match(pattern) ){
      $(this).addClass("invalid").attr("title", "メールアドレスが不適切です");
    }else{
      $(this).removeClass("invalid");
    };
  });
  
  // when name is too short / long, change color
  $("#user_name").on("change", function(){
    var value = $(this).val()
    if(value == ""){
      $(this).addClass("invalid").attr("title", "名前は必須項目です。")
    }else if(value.length < 2){
      $(this).addClass("invalid").attr("title", "名前が短すぎます。");
    }else if(value.length > 20){
      $(this).addClass("invalid").attr("title", "名前が長すぎます");
    }
    else{
      $(this).removeClass("invalid");
    }
  })
  
  // when introduction is too long, change color
  $("#user_introduction").on("change", function(){
    var value = $(this).val();
    if(value.length > 100){
      $(this).addClass("invalid").attr("title", "紹介文は100文字以内にしてください。現在" + value.length + "文字");
    }else{
      $(this).removeClass("invalid");
    };
  });
  
  // when password is too short, change color
  $("#user_password").on("change", function(){
    var value = $(this).val();
    if(value == ""){
      $(this).addClass("invalid").attr("title", "パスワードは必須項目です。");
    }
    else if(value.length < 6){
      $(this).addClass("invalid").attr("title", "パスワードが短すぎます。");
    }
    else{
      $(this).removeClass("invalid");
    }
  })
  
  $("#word_name, #word_meaning").on("change", function(){
    var val = $(this).val();
    if(val === ""){
      $(this).addClass("invalid").attr("title", val + "が空欄です。");
    }else{
      $(this).removeClass("invalid");
    }
  })
  
});
