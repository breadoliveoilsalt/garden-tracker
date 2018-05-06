
let userId
let userGardenIds // an array
let indexOfCurrentGarden
let indexOfNextGarden
// let userGardenIdsLength

let currentGardenId
let nextGardenId

// let counter = 0

$(function() {
  getCurrentGardenId()
  getUserGardensIds()
  // attachGardenListeners()
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
      let arr = []
      $(data).each(function (index, element){
        arr.push(element["id"])
      })
        // Store the user's gardens' ids into memory as userGardenIds...
      userGardenIds = arr
      return userGardenIds
    })
    .then(function() {
      indexOfCurrentGarden = getIndex(currentGardenId)
      // debugger
    })
    .then(function(userGardenIds) {
      // debugger

        // ... attach a listener to the "next" button...
      attachGardenListeners()
        // ...and make the button visible
      $("#next_garden_button").attr("class", "visible garden_button")
        // This would probably be where I'd add a previous button if
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

      // I can probably refactor these two into one method
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
        debugger
        gardenDisplay.html("")
      })
      .then(function() {
        // Insert the template for the new garden obtained through the axaj request
        let insert = gardenObject.renderGarden()
        debugger
        gardenDisplay.html(insert)
        gardenDisplay.attr("id", `garden_display_id_${gardenObject.id}`)

        // console.log("Do I have access to gardenObject?")
        // console.log(gardenObject)
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
    return userGardenIds[0]
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
      debugger
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

            //
            //
            // <li> <a href="/users/1/species/4">Basil</a> </li>
            //   <ul>
            //     <li> Quantity: 10</li>
            //   </ul>

      htmlToInsert += "</ul>"

      return htmlToInsert

  }

}

// class Species {
//   constructor(name, product, sunlight, gardens) {
//     this.name = name
//     this.product = product
//     this.sunlight = sunlight
//     this.gardens = gardens
//   }
  // A user's gardens will necessarily have ids in numerical order (e.g., a user's
  // gardens might be ids 2, 5, 7, 15).  So the first step in rendering a ajax request
  // is, on the first request, get all of the ids of the users gardens, to be an array
  // of user_garden_ids.  Then, on the subsequent ajax requests, the request will cycle
  // through this array to pull up the user's next garden.

  // NO: this is actually how to do it:  when the document loads, get the array of garden_ids;
  // once it is there, then you can add the button!  That way I have it once, and the ajax request
  // can still happen



// This is getting too complicated.
// Everytime: fetch the ids of the user's garden
// Then see where we are in the list
// Then advance to the next element in the list
// Then bring that up

// function attachGardenListeners() {
//   $(".next_garden_button").on("click", function(e) {
//
//         // not sure if i need this:
//       e.preventDefault()
//
//       let userId = $(this).data().userId
//       let gardenId = $(this).data().gardenId
//       let displayBox = $("#garden_display_id_" + gardenId)
//
//
//
//         .then(function(arr) {
//           // make a function to test if current gardenId is the last element
//           // in the array. If so, then modify button to go back to beginning
//           // and add html.  If no, then modify the data of the button and
//           // add the html
//         })
//        })}
//           // return makeIdArray(data)
//
//           // indexOfCurrentGarden = getIndex(gardenId)


      // fetch(`/users/${userId}/get_garden_ids`)
      //   .then(function(data) {
      //     console.log(data)
      //     debugger
      //   }

          // function(data) {
          // return data.json()
        // )
        // .then(function(jsonResp){
        //   console.log(jsonResp)
        // })
//
//   })
// }

      //
      //
      // if (!userGardenIds) {
      //   userGardenIds = getUserGardensIds(userId)
      //   userGardenIdsLength = userGardenIds.length
      //   debugger
      //
      //   // The execution is getting here, but not running the function until it gets passed it.
      // }

      // if (!userGardenIds) {
      //   debugger
      //   getUserGardensIds(userId)
      //   // The execution is getting here, but not running the function until it gets passed it.
      // }
      // debugger


            // let speciesObject = new Species(data["name"], data["product"], data["sunlight"], data["gardens"])
        //     displayBox.append(speciesObject.renderShow())
        //   }).fail(function() {
        //     displayBox.append("Sorry, there was an error.")
        //   })







// function makeIdArray(data) {
//   let arr = []
//   $(data).each(function (index, element){
//     arr.push(element["id"])
//   })
//   return arr
// }


      // I could get all of the gardens and then cycle through them one at a time
      // I could make a ajax request to a new route...which would return all of the ids of the gardens.  Then make a second ajax request for the garden.

      //
      //   // To prevent duplication of data insert in event user clicks on link twice.
      //   // displayBox.empty() works but looks awkward when the request is made
      //
      // if (displayBox.text() === "") {
      //   $.ajax({
      //     url: `/users/${user_id}/species/${species_id}.json`,
      //     method: "GET"
      //   }).done(function(data){
      //     let speciesObject = new Species(data["name"], data["product"], data["sunlight"], data["gardens"])
      //     displayBox.append(speciesObject.renderShow())
      //   }).fail(function() {
      //     displayBox.append("Sorry, there was an error.")
      //   })
      // }
//    }) // end of .on("click")
// }

// class Species {
//   constructor(name, product, sunlight, gardens) {
//     this.name = name
//     this.product = product
//     this.sunlight = sunlight
//     this.gardens = gardens
//   }
//
//   renderShow() {
//     let gardens = $(this.gardens)
//     return `
//       Product: ${this.product} <br>
//       Sunlight: ${this.sunlight} <br>
//       Your Gardens Where This Appears: <br> ${this.renderGardens(gardens)}
//       `
//   }
//
//   renderGardens(gardens) {
//       // Note that gardens here is jQuery object
//     let text = ""
//
//     gardens.each(function(index, garden) {
//       text += `<a class="indented" href="/users/${garden['user_id']}/gardens/${garden['id']}"> ${garden['name']} </a> <br>`
//     })
//
//     return text
//       // `<a href="/users/${garden['user_id']}/gardens/${garden['id']}"> garden['name'] </a> <br>`
//
//   }
// }
//

// make sure to note that data on garden will change
// I'll need to find next garden
