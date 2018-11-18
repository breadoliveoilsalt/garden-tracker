$(function () {
  $(".top_menu").filter(function() {return this.href == location.href}).addClass("active").siblings().removeClass("active")
})
