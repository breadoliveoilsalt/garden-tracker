$(function () {
  $(".top_menu").filter(function() {return this.href == location.href}).addClass("active").siblings().removeClass("active")
  // const menuItems = $(".top_menu")
  //
  // for (let i = 0; i < menuItems.length; i++) {
  //   menuItems[i].on("click", function(){
  //     let current = $(".active")
  //     debugger
  //   })
  // }

  //   menuItems[i].addEventListener("click", function() {
  //     let current = $(".active")
  //     current[0].className = current[0].className.replace(" active", "")
  //     this.className += " active"
  //   });
  // }

  // $(".top_menu").on("click", function() {
  //   debugger
    // $(".active").removeClass("active")
    // $(this).addClass("active")

    // filter(function(){return this.href==location.href}).parent().addClass('active').siblings().removeClass('active')
  // })

})
