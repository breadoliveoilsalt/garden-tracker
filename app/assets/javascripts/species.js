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
        let speciesObject = new Species(data["name"], data["product"], data["sunlight"], data["gardens"])
        let $displayBox = $("#species_display_id_" + species_id)
        console.log(speciesObject)
        $displayBox.append(speciesObject.product)
      })
  })
}

class Species {
  constructor(name, product, sunlight, gardens) {
    this.name = name
    this.product = product
    this.sunlight = sunlight
    this.gardens = gardens
  }

  renderShow() {
    return

  }
}

// Produces: vegetables
// Sun Level: full-sun
// Gardens where this species appears:
// Backyard

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
