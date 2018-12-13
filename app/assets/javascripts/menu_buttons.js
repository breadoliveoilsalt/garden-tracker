
(function(setupForMenuLinks){
  setupForMenuLinks(window.jQuery, window, document)
  } (function($, window, document) {

    $(function () {
      $(".top_menu active").removeClass("active")
      $(".top_menu").filter(function() {return this.href == location.href}).addClass("active")
    })
  }
))
