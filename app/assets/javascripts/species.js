$(function () {
  attachListeners()
})


function attachListeners() {
  $(".species_show_link").on("click", function(e) {

      e.preventDefault()

      let user_id = $(this).data().userId
      let species_id = $(this).data().speciesId

      $.ajax({
        url: `/users/${user_id}/species/${species_id}.json`,
        method: "GET"
      }).done(function(data){
        console.log(data)
      })
  })
}

//
//
// $("#previous").on("click", function() {
//       // To clear any previous buttons to make sure prior buttons are not re-loaded per test:
//     $("#games").empty()
//
//     $.ajax({
//       url: "/games",
//       method: "GET"
//     }).done(function(data) {
//       data["data"].forEach( function (hash) {
//         $("#games").append("<button id='game-" + hash["id"] + "' onclick='loadGame(this)' data-id='" + hash["id"] + "'>Game" + hash["id"] + "</button>")
//         })
//     })
//   })

// Add event listener to each of the links with the class
// species-show.  Grab the data (which will be the species id)
// and then make the ajax request.  Don't forget to prevent
//default
