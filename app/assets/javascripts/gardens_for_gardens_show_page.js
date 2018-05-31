
// let userId
  // aGain watch global variables!
  // Refactor global variables -- main problem is that they are
  // available in the console -- so can give away a lot of information.
  // Keeping the variables within the scope of functions prevents this.
  // I'll have to check all the js files.
  // And don't forget to change the application.js stuff to add the js


  // And watch all snake case
  // And have to get the garden show page button working again Where
  // user_id was changed to userID
  // remember that her suggestion was to have users/2.json and have that
  // list all the gardens through serializer, and then you could have access to
  // this list and just cycle through it
    // If I do that, then I could start of with an if statement  -- if There
    // is not master list of gardens here...then make the request...otherwise,
    // show stuff for the next request
let userGardenIds // an array
let indexOfCurrentGarden
let indexOfNextGarden

let currentGardenId
let nextGardenId

// Note that these two:
  // $(window).load(function() { //
  // $(document).ready()
    // ... would not work due to turbolinks v5 issue
    // When turbolinks was active, this would work in garden.js, button
    // not species.js:
      // $(document).on('turbolinks:load', function() {} etc.

$(function () {
  getCurrentGardenId()
  getUserGardensIds()
})


function getUserGardensIds() {
  let userId = $("#next_garden_button").data().userId
  // An alternate: userId = parseInt(window.location.pathname.split('/')[2])

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
        let insert = gardenObject.renderGardenShow()
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
  constructor(id, name, description, squareFeet, userId, user, species, plantings) {
      // Watch for camel case vs snake case
    this.id = id
    this.name = name
    this.description = description
    this.squareFeet = squareFeet
    this.userId = userId
    this.user = user
    this.species = species
    this.plantings = plantings
  }

  renderGardenShow() {

    let htmlToInsert = `
            <h1>${this.name} </h1>

                  <h2>
                    <a href="/gardens/${this.id}/plantings/new">Add a Planting</a> |
                    <a href="/gardens/${this.id}/edit">Edit Garden</a> |
                    <a data-confirm="Are you sure you want to delete this garden?" rel="nofollow" data-method="delete" href="/gardens/${this.id}">Delete Garden</a>
                </h2>


            <h2> Creater: <a href="/users/${this.userId}/gardens">${this.user.name}</a></h2>

            <h2> Description: ${this.description} </h2>

            <h2> Square Feet: ${this.squareFeet}</h2>

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

  renderGardenListItem() {
    return `
      ${this.name} |
      <a href="${this.userId}/gardens/${this.id}">Garden Details</a> |
      <a href="/gardens/${this.id}/plantings/new">Add a Planting</a> |
      <a href="/gardens/${this.id}/edit">Edit Garden</a> |
      <a data-confirm="Are you sure you want to delete this garden?" rel="nofollow" data-method="delete" href="/gardens/${this.id}">Delete Garden</a>
    `
  }

}
