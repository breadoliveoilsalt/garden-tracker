
let userId
let userGardenIds // an array
let indexOfCurrentGarden
let indexOfNextGarden

let currentGardenId
let nextGardenId

// Note that these two:
  // - $(window).load(function() { //
  // $(document).ready()
    // ... would not work due to turbolinks v5 issue

$(document).on('turbolinks:load', function() {
  getCurrentGardenId()
  getUserGardensIds()
})


function getUserGardensIds() {
  userId = $("#next_garden_button").data().userId
  // userId = parseInt(window.location.pathname.split('/')[2])

  $.ajax({
        // Get the json representing the ids of a user's gardens
      url: `/users/${userId}/get_garden_ids`,
      method: "GET"
    })

        // Turn the json response into an array of the gardens ids
    .then(function(data){
        // I can clean this up...make arr be userGardenIds
      userGardenIds = []
      $(data).each(function (index, element){
        userGardenIds.push(element["id"])
      })
        // Store the user's gardens' ids into memory as userGardenIds.
      return userGardenIds
    })
    .then(function() {
        // Get the index of the current garden of userGardenIds so
        // the script can cycle through to the first garden after
        // it reaches the last and the next button is clicked.
      indexOfCurrentGarden = getIndex(currentGardenId)
    })
    .then(function(userGardenIds) {
        // ... attach a listener to the "next" button...
      attachGardenListeners()
        // ...and make the button visible.
      $("#next_garden_button").attr("class", "visible garden_button")
        // This would probably be where I'd add a "get previous" button if
        // the garden loaded initially was not the first garden
    })
}

function attachGardenListeners() {
  $("#next_garden_button").on("click", function(e) {
    e.preventDefault()

    let gardenObject
    let gardenDisplay

      // These two next lines together get the id of the next gardens
      // in the userGardenIds, or if the current garden is the user's last garden,
      // they go back to the user's first garden.

    indexOfNextGarden = getIndexOfNextGarden()
    nextGardenId = userGardenIds[indexOfNextGarden]


    $.ajax({
          // Get the json representing the ids of a user's gardens
        url: `/users/${userId}/gardens/${nextGardenId}.json`,
        method: "GET"
      })
          // Create an "instance" of the gardenObject
      .then(function(data) {
        gardenObject = new Garden(data["id"], data["name"], data["description"], data["square_feet"], data["user_id"], data["user"], data["species"], data["plantings"])
      })
        // Clear the current garden information
      .then(function () {
        gardenDisplay = $(`#garden_display_id_${currentGardenId}`)
        gardenDisplay.html("")
      })
        // Insert the template for the new garden obtained through the axaj request
      .then(function() {
        let insert = gardenObject.renderGarden()
        gardenDisplay.html(insert)
        gardenDisplay.attr("id", `garden_display_id_${gardenObject.id}`)
        // Finally, reset all the global variables
        // and amend the "Next Garden" button so that it calls the
        // next garden. //
      }).then(function() {
        $("#next_garden_button").attr("data-garden-id", nextGardenId)
        currentGardenId = nextGardenId
        indexOfCurrentGarden = getIndex(currentGardenId)
      })
  })
}

function getCurrentGardenId() {
  currentGardenId = $("#next_garden_button").data().gardenId
}

function getIndex(currentGardenId) {
  let index
  $(userGardenIds).each( function (i, e) {
    if (e === currentGardenId) {
      index = i
    }
  })
  return index
}

function getIndexOfNextGarden() {
  if (indexOfCurrentGarden === userGardenIds.length - 1) {
    return 0
  }
  else {
    return indexOfCurrentGarden + 1
  }
}

class Garden {
  constructor(id, name, description, square_feet, user_id, user, species, plantings) {
    this.id = id
    this.name = name
    this.description = description
    this.square_feet = square_feet
    this.user_id = user_id
    this.user = user
    this.species = species
    this.plantings = plantings
  }

  renderGarden() {

    let htmlToInsert = `
            <h1>${this.name} </h1>

                  <h2>
                    <a href="/gardens/${this.id}/plantings/new">Add a Planting</a> |
                    <a href="/gardens/${this.id}/edit">Edit Garden</a> |
                    <a data-confirm="Are you sure you want to delete this garden?" rel="nofollow" data-method="delete" href="/gardens/${this.id}">Delete Garden</a>
                </h2>


            <h2> Creater: <a href="/users/${this.user_id}/gardens">${this.user.name}</a></h2>

            <h2> Description: ${this.description} </h2>

            <h2> Square Feet: ${this.square_feet}</h2>

        `

      htmlToInsert += this.renderPlantings()
      return htmlToInsert

  }

  renderPlantings() {
    let htmlToInsert = `
        <h3> Plantings: </h3>

          <ul>
      `

    for (var x of this.plantings) {
      htmlToInsert += `
        <li> <a href="/users/${userId}/species/${x.id}">${x.name}</a> </li>
          <ul>
            <li> Quantity: ${x.quantity} </li>
          </ul>
        `
    }

      htmlToInsert += "</ul>"

      return htmlToInsert

  }

}
