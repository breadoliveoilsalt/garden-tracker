$(function () {
  attachListeners()
})


function attachListeners() {
  $(".species_show_link").on("click", function() {
      alert("show link clicked!")
  })
}



// Add event listener to each of the links with the class
// species-show.  Grab the data (which will be the species id)
// and then make the ajax request.  Don't forget to prevent
//default
